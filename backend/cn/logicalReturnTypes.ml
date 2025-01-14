open Locations
module SymSet = Set.Make(Sym)
module BT = BaseTypes
module RT = ResourceTypes
module IT = IndexTerms


type t = 
  | Define of (Sym.t * IT.t) * info * t
  | Resource of (Sym.t * (RT.t * BT.t)) * info * t
  | Constraint of LogicalConstraints.t * info * t
  | I




let mDefine (name, bound, info) t = 
  Define ((name, bound), info, t)
let mResource (bound, info) t = 
  Resource (bound, info, t)
let mConstraint (bound, info) t = 
  Constraint (bound, info, t)

let mDefines = List.fold_right mDefine
let mResources = List.fold_right mResource
let mConstraints = List.fold_right mConstraint


let rec subst (substitution: IT.t Subst.t) lrt = 
  match lrt with
  | Define ((name, it), info, t) ->
     let it = IT.subst substitution it in
     let name, t = suitably_alpha_rename substitution.relevant (name, IT.bt it) t in
     Define ((name, it), info, subst substitution t)
  | Resource ((name, (re, bt)), info, t) -> 
     let re = RT.subst substitution re in
     let name, t = suitably_alpha_rename substitution.relevant (name, bt) t in
     let t = subst substitution t in
     Resource ((name, (re, bt)), info, t)
  | Constraint (lc, info, t) -> 
     let lc = LogicalConstraints.subst substitution lc in
     let t = subst substitution t in
     Constraint (lc, info, t)
  | I -> 
     I

and alpha_rename_ s' (s, ls) t =
  (s', subst (IT.make_subst [(s, IT.sym_ (s', ls))]) t)

and alpha_rename (s, ls) t = 
  let s' = Sym.fresh_same s in
  alpha_rename_ s' (s, ls) t

and suitably_alpha_rename syms (s, ls) t = 
  if SymSet.mem s syms
  then alpha_rename (s, ls) t
  else (s, t)



let rec bound = function
  | Define ((s, _), _, lrt) -> SymSet.add s (bound lrt)
  | Resource ((s, _), _, lrt) -> SymSet.add s (bound lrt)
  | Constraint (_, _, lrt) -> bound lrt
  | I -> SymSet.empty


let alpha_unique ss =
  let rec f ss = function
  | Resource ((name, (re, bt)), info, t) ->
     let t = f (SymSet.add name ss) t in
     let (name, t) = suitably_alpha_rename ss (name, bt) t in
     Resource ((name, (re, bt)), info, t)
  | Define ((name, it), info, t) ->
     let t = f (SymSet.add name ss) t in
     let name, t = suitably_alpha_rename ss (name, IT.bt it) t in
     Define ((name, it), info, t)
  | Constraint (lc, info, t) -> Constraint (lc, info, f ss t)
  | I ->
     I
  in f ss


let binders = 
  let rec aux = function
    | Define ((s, it), _, t) ->
       let (s, t) = alpha_rename (s, IT.bt it) t in
       (s, IT.bt it) :: aux t
    | Resource ((s, (re, bt)), _, t) ->
       let (s, t) = alpha_rename (s, bt) t in
       (s, bt) :: aux t
    | Constraint (lc, _, t) ->
       aux t
    | I ->
       []
  in
  aux


let free_vars lrt =
  let rec f = function
  | Define ((nm, it), _, t) ->
     SymSet.union (IT.free_vars it) (SymSet.remove nm (f t))
  | Resource ((nm, (re, _)), _, t) ->
     SymSet.union (RT.free_vars re) (SymSet.remove nm (f t))
  | Constraint (lc, _, t) ->
     SymSet.union (LogicalConstraints.free_vars lc) (f t)
  | I -> SymSet.empty
  in
  f lrt


let simp simp_it simp_lc simp_re = 
  let rec aux = function
    | Define ((s, it), info, t) ->
       let it = simp_it it in
       let s, t = alpha_rename (s, IT.bt it) t in
       Define ((s, it), info, aux t)
    | Resource ((s, (re, bt)), info, t) ->
       let re = simp_re re in
       let s, t = alpha_rename (s, bt) t in
       Resource ((s, (re, bt)), info, aux t)
    | Constraint (lc, info, t) ->
       let lc = simp_lc lc in
       Constraint (lc, info, aux t)
    | I ->
       I
  in
  aux





let rec pp_aux lrt =
  let open Pp in
  match lrt with
  | Define ((name, it), _info, t) ->
     group (!^"let" ^^^ (Sym.pp name) ^^^ equals ^^^ IT.pp it ^^ semi) :: pp_aux t
  | Resource ((name, (re, bt)), _info, t) ->
     group (!^"let" ^^^ (Sym.pp name) ^^^ equals ^^^ RT.pp re ^^ semi) :: pp_aux t
  | Constraint (lc, _info, t) ->
     let op = if !unicode then utf8string "\u{2227}" else slash ^^ backslash in
     group (LogicalConstraints.pp lc ^^^ op) :: pp_aux t
  | I -> 
     [!^"I"]

let pp rt = 
  Pp.flow (Pp.break 1) (pp_aux rt) 



let rec json = function
  | Define ((s, it), _info, t) ->
     let args = [
         ("symbol", Sym.json s);
         ("term", IT.json it);
         ("return_type", json t);
       ]
     in
     `Variant ("Define", Some (`Assoc args))
  | Resource ((s, (r, _bt)), _info, t) ->
     let args = [
         ("symbol", Sym.json s);
         ("resource", RT.json r);
         ("return_type", json t);
       ]
     in
     `Variant ("Resource", Some (`Assoc args))
  | Constraint (lc, _info, t) ->
     let args = [
         ("constraint", LogicalConstraints.json lc);
         ("return_type", json t);
       ]
     in
     `Variant ("Constraint", Some (`Assoc args))
  | I ->
     `Variant ("I", None)
     
