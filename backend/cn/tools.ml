let id = fun x -> x

let comp (f : 'b -> 'c) (g : 'a -> 'b) (x : 'a) : 'c = f (g (x))
let rec comps (fs : ('a -> 'a) list) (a : 'a) : 'a =
  match fs with
  | [] -> a
  | f :: fs -> f (comps fs a)


let curry f a b = f (a, b)
let uncurry f (a, b) = f a b


let do_stack_trace () = 
  let open Debug_ocaml in
  if !debug_level > 0 then 
    let backtrace = Printexc.get_callstack 200 in
    Some (Printexc.raw_backtrace_to_string backtrace)
  else 
    None



let pair_equal equalityA equalityB (a,b) (a',b') = 
  equalityA a a' && equalityB b b'



(* let at_most_one err_str = function
 *   | [] -> None
 *   | [x] -> (Some x)
 *   | _ -> Debug_ocaml.error err_str *)




let unsupported (loc : Locations.t) (err : Pp.document) : 'a = 
  let trace = Option.map Pp.string (do_stack_trace ()) in
  Pp.error loc err (Option.to_list trace);
  exit 2



let skip swith lrt = if true then swith else lrt



let todo_string_of_sym (Cerb_frontend.Symbol.Symbol (_, _, sd)) =
  match sd with
    | SD_Id str 
    | SD_CN_Id str 
    | SD_ObjectAddress str 
    | SD_FunArgValue str ->
        str
    | _ ->
        assert false
