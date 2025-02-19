open Resultat
open Effectful.Make(Resultat)
open TypeErrors
open IndexTerms



(* builtin function symbols *)

let mk_arg1 mk loc = function
  | [x] -> return (mk x)
  | xs -> fail {loc; msg = Number_arguments {has = List.length xs; expect = 1}}

let mk_arg2 mk loc = function
  | [x; y] -> return (mk (x, y))
  | xs -> fail {loc; msg = Number_arguments {has = List.length xs; expect = 2}}


let mul_uf_def = (Sym.fresh_named "mul_uf", mk_arg2 mul_no_smt_)
let div_uf_def = (Sym.fresh_named "div_uf", mk_arg2 div_no_smt_)
let power_uf_def = (Sym.fresh_named "power_uf", mk_arg2 exp_no_smt_)
let rem_uf_def = (Sym.fresh_named "rem_uf", mk_arg2 rem_no_smt_)
let mod_uf_def = (Sym.fresh_named "mod_uf", mk_arg2 mod_no_smt_)
let xor_uf_def = (Sym.fresh_named "xor_uf", mk_arg2 xor_no_smt_)

let power_def = (Sym.fresh_named "power", mk_arg2 exp_)
let rem_def = (Sym.fresh_named "rem", mk_arg2 rem_)
let mod_def = (Sym.fresh_named "mod", mk_arg2 mod_)

let not_def = (Sym.fresh_named "not", mk_arg1 not_)

let builtin_funs = 
  List.map (fun (s, mk) -> (Sym.pp_string s, mk)) [
      mul_uf_def;
      div_uf_def;
      power_uf_def;
      rem_uf_def;  
      mod_uf_def;
      xor_uf_def;

      power_def;
      rem_def;
      mod_def;

      not_def;
    ]

let apply_builtin_funs loc nm args =
  match List.assoc_opt String.equal nm builtin_funs with
  | None -> return None
  | Some mk ->
    let@ t = mk loc args in
    return (Some t)

