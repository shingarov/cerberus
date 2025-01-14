open Locations
module SymSet = Set.Make(Sym)
module IT = IndexTerms

module LRT = LogicalReturnTypes

type t = Computational of (Sym.t * BaseTypes.t) * info * LRT.t




let mComputational (name, bound, oinfo) t = 
  Computational ((name, bound), oinfo, t)






let rec subst (substitution: IT.t Subst.t) at =
  match at with
  | Computational ((name, bt), info, t) -> 
     let name, t = LRT.suitably_alpha_rename substitution.relevant (name, bt) t in
     Computational ((name, bt), info, LRT.subst substitution t)

and alpha_rename (s, ls) t = 
  let s' = Sym.fresh_same s in
  (s', subst (IT.make_subst [(s, IT.sym_ (s', ls))]) t)

and suitably_alpha_rename syms (s, ls) t = 
  if SymSet.mem s syms 
  then alpha_rename (s, ls) t
  else (s, t)


let alpha_unique ss = function
  | Computational ((name, bt), oinfo, t) ->
    let t = LRT.alpha_unique (SymSet.add name ss) t in
    let (name, t) = LRT.suitably_alpha_rename ss (name, bt) t in
    Computational ((name, bt), oinfo, t)


let simp simp_it simp_lc simp_re = function
  | Computational ((s, bt), info, lt) ->
     let s, lt = LRT.alpha_rename (s, bt) lt in
     Computational ((s, bt), info, LRT.simp simp_it simp_lc simp_re lt)


let binders = function
  | Computational ((s, bt), _, t) ->
     let (s, t) = LRT.alpha_rename (s, bt) t in
     (s, bt) :: LRT.binders t


let map (f : LRT.t -> LRT.t) = function
  | Computational (param, oinfo, t) -> Computational (param, oinfo, f t)


let bound = function
  | Computational ((s, _), _, lrt) ->
     SymSet.add s (LRT.bound lrt)



let pp_aux rt = 
  let open Pp in
  match rt with
  | Computational ((name, bt), oinfo, t) ->
     let op = if !unicode then utf8string "\u{03A3}" else !^"EC" in
     (op ^^^ typ (Sym.pp name) (BaseTypes.pp bt) ^^ dot) :: LRT.pp_aux t

let pp rt = 
  Pp.flow (Pp.break 1) (pp_aux rt)



let json = function
  | Computational ((s, bt), oinfo, t) ->
     let args = [
         ("symbol", Sym.json s);
         ("basetype", BaseTypes.json bt);
         ("return_type", LRT.json t);
       ]
     in
     `Variant ("Computational", Some (`Assoc args))



