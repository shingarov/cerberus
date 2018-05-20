(* Adapted from cppmem model exploration tool *)

(*========================================================================*)
(*                                                                        *)
(*             cppmem model exploration tool                              *)
(*                                                                        *)
(*                    Mark Batty                                          *)
(*                    Scott Owens                                         *)
(*                    Jean Pichon                                         *)
(*                    Susmit Sarkar                                       *)
(*                    Peter Sewell                                        *)
(*                                                                        *)
(*  This file is copyright 2011, 2012 by the above authors.               *)
(*                                                                        *)
(*  Redistribution and use in source and binary forms, with or without    *)
(*  modification, are permitted provided that the following conditions    *)
(*  are met:                                                              *)
(*  1. Redistributions of source code must retain the above copyright     *)
(*  notice, this list of conditions and the following disclaimer.         *)
(*  2. Redistributions in binary form must reproduce the above copyright  *)
(*  notice, this list of conditions and the following disclaimer in the   *)
(*  documentation and/or other materials provided with the distribution.  *)
(*  3. The names of the authors may not be used to endorse or promote     *)
(*  products derived from this software without specific prior written    *)
(*  permission.                                                           *)
(*                                                                        *)
(*  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS    *)
(*  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED     *)
(*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE    *)
(*  ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY       *)
(*  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL    *)
(*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE     *)
(*  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS         *)
(*  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHE   *)
(*  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR       *)
(*  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN   *)
(*  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                         *)
(*========================================================================*)



open Auxl
open Bmc_conc_types
open Printf
open Z3

let pp_memory_order = function
  | NA -> "na"
  | Seq_cst -> "sc"
  | Relaxed -> "rlx"
  | Release -> "rel"
  | Acquire -> "acq"
  | Consume -> "con"
  | Acq_rel -> "a/r"

let pp_memory_order_enum2 = fun () -> pp_memory_order

let pp_memory_order_enum3 m () = 
  function mo -> 
    sprintf "%a" pp_memory_order_enum2 mo


let pp_tid = string_of_int
let pp_aid = string_of_int
let pp_loc () = function
  | ConcreteLoc l -> string_of_int l
  | SymbolicLoc l -> l

let pp_thread_id () tid =
  pp_tid tid

let pp_value () = function
  | Rigid _ ->
      assert false
  | Flexible s -> s
  | Z3Expr expr -> Expr.to_string expr

let pp_action_long = function
  | Load (aid, tid, memord, loc, cval) ->
    sprintf "%s:Load %s @%s %s %s" (pp_aid aid) (pp_tid tid) (pp_loc () loc) 
                                  (pp_memory_order memord) (pp_value () cval)
  | Store (aid, tid, memord, loc, cval) ->
    sprintf "%s:Store %s @%s %s %s" (pp_aid aid) (pp_tid tid) (pp_loc () loc) 
                                   (pp_memory_order memord) (pp_value () cval)
  | _ -> assert false

let pp_location_kind = function
  | Non_Atomic -> "na"
  | Atomic     -> "atomic"
  | Mutex      -> "mutex"


let pp_preexecution (preexec: pre_execution) =
  print_endline "===ACTIONS";
  List.iter (fun action ->
    print_endline (pp_action_long action)) preexec.actions;
  print_endline "===Threads";
  List.iter (fun tid ->
    Printf.printf "%d " tid) preexec.threads;
  print_endline "===SB";
  List.iter (fun (a1, a2) ->
    Printf.printf "(%s,%s)\n" (pp_action_long a1) (pp_action_long a2);
  ) preexec.sb;
  print_endline "===ASW";
  List.iter (fun (a1, a2) ->
    Printf.printf "(%s,%s)\n" (pp_action_long a1) (pp_action_long a2);
  ) preexec.asw;
  print_endline "===LK";
  Pmap.iter (fun loc kind ->
    Printf.printf "@%s -> %s\n" (pp_loc () loc) (pp_location_kind kind)
  ) preexec.lk


let pp_witness (witness: execution_witness) =
  print_endline "===RF";
  List.iter (fun (a1, a2) ->
    Printf.printf "(%s,%s)\n" (pp_action_long a1) (pp_action_long a2);
  ) witness.rf;
  print_endline "===MO";
  List.iter (fun (a1, a2) ->
    Printf.printf "(%s,%s)\n" (pp_action_long a1) (pp_action_long a2);
  ) witness.mo;
  print_endline "===SC";
  List.iter (fun (a1, a2) ->
    Printf.printf "(%s,%s)\n" (pp_action_long a1) (pp_action_long a2);
  ) witness.sc;

type column_head = 
  | CH_tid of tid
  | CH_loc of location


type layout = {
    columns : ((column_head*(int*int)) * (action * (int*int)) list) list;
    column_of : action -> int;
    size_x : int;
    size_y : int;
    relabelling : (aid*string) list * (tid*string) list 
  }

let layout_by_thread (do_relabel: bool) (preexec : pre_execution) : layout =
  let sb a1 a2 =
    if List.mem (a1, a2) preexec.sb then -1
    else if List.mem (a2,a1) preexec.sb then 1
    else 0 in
  let sorted_threads = List.sort 
      (fun tid1 tid2 -> compare tid1 tid2) 
      preexec.threads in
  let actions_of_thread tid = List.filter 
      (fun a -> tid = tid_of a) 
      preexec.actions in  
  let actions_by_column = 
    List.map 
      (function tid -> 
        (CH_tid tid,
         List.stable_sort 
           sb 
           (actions_of_thread tid)))
      sorted_threads in

  let size_x = List.length actions_by_column in
  let size_y = List.fold_left max 0 (List.map (function (ch,actions) -> 1+List.length actions) actions_by_column) in

  let rec add_coords_col actions x y = 
    match actions with 
    | [] -> [] 
    | a::actions' -> (a,(x,y)):: add_coords_col actions' x (y+1) in

  let rec add_coords x abc = 
    let x_offset,y_offset = 0,0 in
    match abc with
    | [] -> []
    | (ch,actions)::abc' -> 
        ((ch,(x+x_offset,0+y_offset)),add_coords_col actions (x+x_offset) (1+y_offset)) :: add_coords (x+1) abc' in

  let actions_by_column_with_coords = add_coords 0 actions_by_column in

  let rec action_relabelling_column actions n acc =
    match actions with
    | [] -> (acc,n)
    | (a,(x,y))::actions' ->
        let new_label =
          if n < 25 then String.make 1 (Char.chr (n+Char.code 'a'))
          else sprintf "z%i" n in
        action_relabelling_column actions' (n+1) ((aid_of a,new_label)::acc) in
  let rec action_relabelling_columns abc n acc =
    match abc with
    | [] -> acc
    | (ch,actions)::abc' -> 
        let (acc',n') = action_relabelling_column actions n acc in
        action_relabelling_columns abc' n' acc' in

  let rec thread_relabelling ts n acc = 
    match ts with
    | [] -> acc
    | tid::ts' -> 
        let new_label = (sprintf "%i" n) in
        thread_relabelling ts' (n+1) ((tid,new_label)::acc) in
  let action_relabelling : (aid * string) list = action_relabelling_columns actions_by_column_with_coords 0 [] in

  let thread_relabelling : (tid * string) list = thread_relabelling sorted_threads 0 [] in
  { columns = actions_by_column_with_coords;
    column_of = (function a -> let rec f ts n = match ts with tid::ts' -> if tid_of a = tid then n else f ts' (n+1) | [] -> raise (Failure "thread id not found") in f sorted_threads 0);
    size_x = size_x; 
    size_y = (*if (match m.layout with LO_neato_par_init -> true | _->false) then 2*size_y +2 else*) 1*size_y+2 ; (* +2 for possible constraint *) 
    relabelling = if do_relabel then (action_relabelling,thread_relabelling) else ([],[])}

let rec pp_action rl () a = match a with
  | Lock (aid,tid,l,oc) -> 
      assert false
  | Unlock (aid,tid,l) ->
      assert false
  | Load (aid,tid,mo,l,v) ->
     sprintf "%a,%a:Load %a %a %a" (pp_action_id' rl) aid  (pp_thread_id' rl) tid  pp_memory_order_enum2 mo  pp_loc l  pp_value v
  | Store (aid,tid,mo,l,v) ->
     sprintf "%a,%a:Store %a %a %a" (pp_action_id' rl) aid  (pp_thread_id' rl) tid  pp_memory_order_enum2 mo  pp_loc l  pp_value v
  | RMW (aid,tid,mo,l,v1,v2) ->
     sprintf "%a,%a:RMW %a %a %a %a" (pp_action_id' rl) aid  (pp_thread_id' rl) tid  pp_memory_order_enum2 mo  pp_loc l  pp_value v1  pp_value v2
  | Blocked_rmw (aid,tid,l) ->
      assert false
  | Fence (aid,tid,mo) ->
      assert false

and pp_action_id () aid = string_of_int aid

and pp_action_id' rl () aid = 
  let (action_relabelling,thread_relabelling) = rl in 
  try List.assoc aid action_relabelling with Not_found -> pp_action_id () aid

and pp_thread_id' rl () tid =
  let (action_relabelling,thread_relabelling) = rl in 
  try List.assoc tid thread_relabelling with Not_found -> pp_thread_id () tid

and pp_action_thread_id' m rl () (aid,tid) = 
  if m.thread_ids then
    sprintf "%a,%a" (pp_action_id' rl) aid (pp_thread_id' rl) tid
  else
    sprintf "%a" (pp_action_id' rl) aid 

and pp_action' m rl () = function a -> match a with
  | Lock (aid,tid,l,oc) -> 
      assert false
  | Unlock(aid,tid,l) ->
      assert false
  | Load (aid,tid,mo,l,v) ->
      let fmt =
        if m.texmode then format_of_string "\\\\RA{%a}{%a}{%a}{%a}" else format_of_string "%a:R%a %a=%a" in
      sprintf fmt (pp_action_thread_id' m rl) (aid,tid)  (pp_memory_order_enum3 m) mo  pp_loc l  pp_value v
  | Store (aid,tid,mo,l,v) ->
      let fmt =
        if m.texmode then format_of_string "\\\\WA{%a}{%a}{%a}{%a}" else format_of_string "%a:W%a %a=%a" in 
     sprintf fmt (pp_action_thread_id' m rl) (aid,tid)  (pp_memory_order_enum3 m) mo  pp_loc l  pp_value v
  | RMW (aid,tid,mo,l,v1,v2) ->
      assert false
  | Blocked_rmw (aid,tid,l) ->
      assert false
  | Fence (aid,tid,mo) ->
      assert false

and pp_column_head rl () = function 
  | CH_tid tid -> sprintf "%a" (pp_thread_id' rl) tid
  | CH_loc loc -> sprintf "%a" pp_loc loc

exception NonLinearSB

let partition_faults faults =
  let (unary,binary) =
    List.fold_left
      (fun (un,bin) (nm,fault) -> match fault with
        | One acts -> ((nm,acts) :: un,bin)
        | Two rel -> (un,(nm,rel) :: bin))
      ([],[]) faults in
  (List.rev unary, List.rev binary)


let pp_dot () (m, (preexec, exedo, exddo)) =
              (*(m: ppmode)
              (preexec : pre_execution) 
              (witness : execution_witness) *)
  let lo = layout_by_thread false preexec in

  let fontsize_node   = m.fontsize in
  let fontsize_edge   = m.fontsize in
  let fontsize_legend = m.fontsize in

  let fontname_node   = m.fontname in
  let fontname_edge   = m.fontname in
  let fontname_legend = m.fontname in

  let pp_attr () (attr,v) = match v with
  | "" -> ""
  | _  -> sprintf ", %s=\"%s\"" attr v in

  let pp_intattr () (attr,v) =
    sprintf ", %s=%i" attr v in

  let pp_floatattr () (attr,v) =
    sprintf ", %s=%s" attr (string_of_float v) in
  
  let pp_fontsize () f = pp_intattr () ("fontsize",f) in

  let pp_color () color = pp_attr () ("color",color) in

  let pp_fontcolor () color = pp_attr () ("fontcolor",color) in

  let pp_fontname () fontname = pp_attr () ("fontname",fontname) in

  let pp_extra () attr_value = match attr_value  with
  | "" -> ""
  | _  -> sprintf "%s" attr_value in

  let pl () = sprintf  "%s\n" in
  let pf () fmt = sprintf fmt in

  let escape_tex s =
    let buff = Buffer.create 16 in
    for k=0 to String.length s-1 do
      let c = s.[k] in
      begin match c with
      | '_' -> Buffer.add_char buff '\\'
      | _ -> ()
      end ;
      Buffer.add_char buff c 
    done ;
    Buffer.contents buff in

  let escape_dot s =
    let buff = Buffer.create 16 in
    for k=0 to String.length s-1 do
      let c = s.[k] in
      begin match c with
      | '\\' -> Buffer.add_char buff '\\'
      | _ -> ()
      end ;
      Buffer.add_char buff c 
    done ;
    Buffer.contents buff in
      
  let escape_label s = escape_dot (escape_tex s) in

  let pp_edge_label () (m, lbl) =
    (* escape_label lbl in *)
    if m.texmode then
      "\"" ^ String.concat "," (List.map (fun (l,c) -> "\\\\color{" ^ c ^ "}{" ^ l ^ "}") lbl) ^ "\""
    else "<" ^ String.concat "," (List.map (fun (l,c) -> "<font color=\"" ^ c ^ "\">" ^ l ^ "</font>") lbl) ^ ">" in

  let pp_node_name () a = sprintf "node%s" (pp_aid (aid_of a)) in

  let pp_column_head_node_name () (x,y) = sprintf "column%i%i" x y in

  let is_ur_or_dr lbls =
    match lbls with
        (* TODO: jp: the information of which relations are faults should be piped to here *)
      | [(lbl, _)] -> List.mem lbl ["ur";"dr"]
      | _ -> false in

  let pp_edge () m a1 a2 lbl colours style arrowsize extra_attr =
    let colour = String.concat ":" colours in
    sprintf "%a -> %a [label=%a%s%a%a%a%a%a%s%a]%a;\n"
      pp_node_name a1 
      pp_node_name a2  
      pp_edge_label (m, lbl)
      "" (* (if filled then ",style=\"filled\",labelfloat=\"true\"" else "") *)
      pp_attr ("color",colour)
      pp_fontname fontname_edge
      pp_fontsize fontsize_edge
      pp_attr ("style",style)
      pp_floatattr ("penwidth",m.penwidth)
      (if is_ur_or_dr lbl then ",constraint=false,arrowhead=\"none\"" else "")
      pp_attr ("arrowsize",arrowsize)
      pp_extra extra_attr  in

  let pp_point () n lbl color pos =
    sprintf "%s [label=\"\", shape=point%a%a];\n" 
      n
      pp_attr  ("color",color)
      pp_extra pos  in

  let max_x = lo.size_x -1 in
  let max_y = lo.size_y -1 in

  let xorigin=1.0 in 
  let yorigin=1.0 in

  let action_position (x,y) = 
    (m.xscale *. float_of_int x +. xorigin),
    (m.yscale *. (float_of_int max_y -. (float_of_int y )) +. yorigin) in
    
  let pp_action_position () (x,y) = 
    let (x',y') = action_position (x,y) in
    sprintf "pos=\"%f,%f!\"" x' y' in

  let pp_init_rf_position () (x,y) = 
    let (x',y') = action_position (x,y) in
    sprintf "pos=\"%f,%f!\"" (x' -. 1.25) (y'+. 0.25) in
  
  let (unary_faults,binary_faults) =
    match exddo with
      | None -> ([],[])
      | Some exdd -> partition_faults exdd.undefined_behaviour in

  let faulty_action_ids =
    List.concat (List.map (fun (_,acts) -> List.map aid_of acts) unary_faults) in



  let axygeometry = sprintf "[margin=\"0.0,0.0\"][fixedsize=\"true\"][height=\"%f\"][width=\"%f\"]" m.node_height m.node_width in
  let chgeometry = "[margin=\"0.0,0.0\"][fixedsize=\"false\"][height=\"0.15\"][width=\"0.1\"]" in
  let pp_axy () color rank (a,(x,y)) =
    sprintf 
      "%a [shape=plaintext%a%a%s%a] %s [label=\"%s\", %a] %s;\n"
      pp_node_name a
      pp_fontname fontname_node
      pp_fontsize fontsize_node
      (if m.filled then ", style=\"filled\"" else "")
      pp_fontcolor color
      rank
      (((pp_action' m lo.relabelling) () a))
      pp_action_position (x,y) 
      axygeometry 
  in

  let pp_column_head_node () (color,rank,(ch,(x,y))) =
    sprintf 
      "%a [shape=box%a%a] %s [label=\"%s\" %a] %s ;\n"
      pp_column_head_node_name (x,y)
      pp_fontsize fontsize_node
      pp_color color
      rank
      (escape_label ((pp_column_head lo.relabelling) () ch))
      pp_action_position (x,y) 
      chgeometry 
  in
  (* TODO *)
  let faulty_action_ids = [] in
  let rec pp_axys () axys = 
    match axys with 
    | [] -> "" 
    | (a,(x,y))::axys' ->
      let color = if List.mem (aid_of a) faulty_action_ids then "darkorange" else "" in
      pp_axy () color "" (a,(x,y)) ^  pp_axys () axys' in

  let rec pp_columns () columns = 
    match columns with
    | [] -> ""
    | ((ch,(x,y)),axys)::columns' -> 
        pl () "/* column */\n" 
        ^ sprintf "%s%a%a" 
          "" (* (if m.neato then pp_column_head_node () ("","",(ch,(x,y))) else "")*)
          pp_axys axys  
          pp_columns columns' in

  let relations = 
    [ ("sb","black", transitive_reduction preexec.sb);
      (*("dd","magenta", transitive_reduction exod.dd);
      ("cd","magenta", transitive_reduction exod.cd); *)
      (* ("asw","deeppink4",preexec.asw) ]  *)
    ]
    @
      (match exedo with None -> [] | Some exed ->
        [ ("rf",  "red",   exed.rf);
          ("sc",  "orange", transitive_reduction exed.sc); 
          ("mo",  "blue",  transitive_reduction exed.mo);
          (* ("lo",  "gray54", transitive_reduction exed.lo);
          ("ao",  "black", exed.ao);
          ("tot", "blue", transitive_reduction exed.tot) *)
        ]) 
    @
      (match exddo with None -> [] | Some exdd ->
        (* TODO: jp: make this generic *)
        let colour_scheme = [
          ("sw", "deeppink4");
          ("rs", "black");
          ("hrs", "black");
          ("cad", "deeppink4");
          ("dob", "deeppink4");
          ("ithb", "forestgreen");
          ("hb", "forestgreen");
          ("vse", "brown");
          ("vsses", "brown4");
          ("dummy", "white")
        ] in
        let try_to_transitive_reduce rel = if is_transitive rel then try transitive_reduction rel with Transitive -> rel else rel in
        (* Note: doing the reduction on each relation is expensive *)
        let colour_and_prepare (nm, rel) =
          (nm,
           (try List.assoc nm colour_scheme with Not_found -> "black"),
           try_to_transitive_reduce rel) in
        List.map colour_and_prepare exdd.derived_relations
        @
        let relation_faults =
          List.map
            (fun (nm, rel) -> (nm, rel))
              (* ((try List.assoc nm Atomic.short_names with Not_found -> nm), rel)) *)
            binary_faults in
        List.map (fun (nm, rel) -> (nm, "darkorange", symmetric_reduction rel)) relation_faults
        ) in
  let debug s = () (* print_string s;flush stdout *) in 
  let relayout_downwards columns = 
    try
      let relayout_downwards_reln = 
        transitive_reduction 
          (transitive_closure
             (reflexive_reduction
                (List.flatten 
                   (option_map 
                      (function (e,c,r) -> 
                        if List.mem e ["dr";"ur"] then None
                        else Some r)
                      relations)))) in
      let check_all_linear_downwards =
        let _,_,sbrel = 
          List.find (fun (name,_,r) -> name = "sb") relations in 
        let rec check_related_by_sb rel =
          match rel with
          | [] -> ()
          | (a,_) :: rel' ->
              if List.exists (fun (a',_) -> List.mem (a,a') sbrel) rel' 
              then check_related_by_sb rel'
              else raise NonLinearSB
        in
        List.iter
          (fun (_,actions) -> check_related_by_sb actions)
          columns
      in    
      let r = ref relayout_downwards_reln in
      let print_r () = debug "r = \n"; List.iter (function (a',b') -> debug (sprintf "   <%a, %a>\n" (pp_action lo.relabelling) a' (pp_action lo.relabelling)  b')) !r; debug "" in
      let () = print_r() in
      let n = List.length columns in
      let a_todo = Array.of_list (List.map (function (_,axys) ->axys) columns) in
      let chs = Array.of_list (List.map (function (ch,_) ->ch) columns) in
      let a_done = Array.make n [] in
      let y_next = Array.make n 0 in
      let y_next' = Array.make n 0 in
      let newly_done = ref [] in
      let print_axy (a,(x,y)) = debug (sprintf "(%a,(%n,%n))[%n] " (pp_action lo.relabelling) a x y (lo.column_of a)) in
      let print_axys axys = List.iter print_axy axys; debug "\n" in 
      let () =
        debug "a_todo: ";
        for i = 0 to n-1 do
          debug (Printf.sprintf "@%i = " i); print_axys (a_todo.(i))
        done;
        debug "\n" 
      in
      let print_r () = debug "r = \n"; List.iter (function (a',b') -> debug (sprintf "   <%a, %a>\n" (pp_action lo.relabelling) a' (pp_action lo.relabelling)  b')) !r; debug "" in
      while Array.fold_right (function a_s -> function b -> (a_s <> [] || b)) a_todo false do
        let _ = read_line () in
        debug "\nnew round:\n";
        print_r ();
        debug "a_todo: ";
        for i = 0 to n-1 do
          debug (Printf.sprintf "@%i = " i); print_axys (a_todo.(i))
        done;
        debug "\n" ;
        debug "y_next:  ";for i = 0 to n-1 do debug (sprintf "%n  " y_next.(i)) done; debug "\n";
        newly_done := [];
        for i = 0 to n-1 do
          match a_todo.(i) with
          | [] -> ()
          | (a,(x,y))::axys' -> 
              if List.exists (function (a',b') -> b'=a) (!r) then ()
              else (
                a_todo.(i)<- axys' ;
                let axy' = (a,(x,y_next.(i))) in
                print_axy axy';
                a_done.(i)<- a_done.(i) @ [axy'];
                newly_done := a :: (!newly_done);
               )
        done;
        debug "newly done: ";
        List.iter (function a -> debug (pp_action lo.relabelling () a)) (!newly_done); debug "\n";
        for i= 0 to n-1 do
          y_next'.(i) <- 
            List.fold_left max
              (y_next.(i) + (if List.exists (function a -> lo.column_of a = i) !newly_done then 1 else 0) )
              ( option_map 
                  (function (a',b') -> 
                    if List.mem a' (!newly_done) && lo.column_of b' = i 
                    then Some (1 + y_next.(lo.column_of a')) 
                    else None)
                  !r )
        done;
        for i = 0 to n-1 do 
          y_next.(i) <- y_next'.(i) 
        done;
        r := List.filter (function (a',b') -> not (List.mem a' (!newly_done))) (!r)
      done;
      Array.to_list (Array.mapi (fun i axys' -> ( chs.(i), a_done.(i))) a_done )
    with 
      Transitive -> 
        debug "relayout_downwards invoked on a transitive set of relations\n"; 
        columns 
    |  NonLinearSB -> 
        debug "relayout_downwards invoked on structure with non-linear sequenced-before relations\n"; 
        columns  in

  let relayout_par_init columns = 
    let column0::columns' = columns in
    let y_start = match column0 with (_,axys) -> List.length axys in
    column0 :: List.map (function (ch,axys) -> (ch, List.map (function (a,(x,y))->(a,(x,y+y_start))) axys)) columns' in
  
  let lo = 
    let columns' = match m.layout with
    | LO_neato_downwards -> relayout_downwards lo.columns 
    | LO_neato_par_init -> relayout_par_init lo.columns
    | LO_dot | LO_neato_par -> lo.columns 
    in
    { lo 
    with 
      columns = columns';
      size_y = List.fold_left max 0 
        (List.map 
           (function (ch,axys) -> 
             1+
               List.fold_right 
               (function (a,(x,y)) -> function y' -> max y y')
               axys
               0
           ) 
           columns')
    } in

  let flattened = List.flatten (List.map (function (e,c,r) -> (List.map (function (a1,a2) -> (e,c,a1,a2)) r)) relations) in

  let source_target_pairs = remove_duplicates (List.map (function (e,c,a1,a2)->(a1,a2)) flattened) in
  
  let glommed_edges = 
    List.map 
      (function (a1',a2') -> 
        let parallel_edges = List.filter (function (e,c,a1,a2)->a1=a1'&&a2=a2') flattened in
        let (_,_,a1,a2) = List.hd parallel_edges in 
(* the following would make multiple labels appear vertically, but the overall layout produced by graphviz is often much worse *)
(*        let labels = "\\\\ml{"^String.concat "\\\\\\\\" (List.map (function (e,_,_,_)-> "\\\\"^e) parallel_edges)^"}" in *)
        let labels = List.map (function (e,c,_,_) -> (e,c)) parallel_edges in
(*         let non_hb_colours = remove_duplicates (option_map (function (e,c,_,_) -> match e with "hb"->None |_->Some c) parallel_edges) in *)
(*         let colour = match non_hb_colours with [c]->c | _ -> "black" in *)
        let colours = remove_duplicates (option_map (function (_,c,_,_) -> Some c) parallel_edges) in
        let arrowsize = match List.length colours with 
        | 1 -> "0.8"
        | 2 -> "1.0"
        | _ -> "1.2" in
        (labels,colours,arrowsize,a1,a2))
      source_target_pairs in

  let pp_graph () legend =
    "digraph G {\n" 
(* this gives *different* results to invoking dot/neato on the command-line *)
(*     ^ " layout = "^(match m.layout with Dot -> "dot" | _ -> "neato") ^"\n"  *)
    ^ " splines=true;\n"
    ^ " overlap=false;\n"
    ^ " ranksep = "^string_of_float m.ranksep ^";\n"  
    ^ " nodesep = "^string_of_float m.nodesep ^";\n" 
(*    ^ " fontname = \""^fontname_graph^"\";\n"*)
    ^ "/* legend */\n" 
    ^ pf () "fontsize=%i fontname=\"%s\" label=\"%s\"; \n\n" fontsize_legend fontname_legend legend 
    ^ "/* columns */\n" 
    ^ pf () "%a" pp_columns lo.columns
    (* ^ pf () "%a" pp_constraint exod.vconstraint *)
    ^ String.concat "" (List.map (function (labels,c,arrowsize,a1,a2) -> pp_edge () m a1 a2 labels c "" arrowsize "") glommed_edges)
    ^ "}" in

   let legend = match m.legend with 
   | None -> ""
   (*
   | Some "filename" -> (match testname with None -> "" | Some testname -> escape_label testname) 
*)
   | Some s -> s in
   
   pp_graph () legend 


