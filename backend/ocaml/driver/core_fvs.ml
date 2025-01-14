(* Created by Victor Gomes 2017-03-10 *)

open Cerb_frontend
open Util
open Symbol
open Core

(* FIXME VICTOR *)
let sym_compare s1 s2 =
  match s1, s2 with
  | Symbol (_, _, Some l1), Symbol (_, _, Some l2) -> String.compare l1 l2
  | Symbol (_, n, Some _), Symbol (_, _, None) -> -1
  | Symbol (_, _, None), Symbol (_, m, Some _) -> 1
  | Symbol (_, n, None), Symbol (_, m, None) -> n - m

let sort_uniq fvs =
  List.sort_uniq sym_compare fvs

let rec fv_rm x = function
  | [] -> []
  | (y::ys) ->
    let xs = fv_rm x ys in
    if x=y then xs else y::xs

let rec fvs_rm xs ys =
  match xs with
  | [] -> ys
  | (x::xs) -> fvs_rm xs (fv_rm x ys)

let rec fv_pat fvs (Pattern (_, pat)) =
  match pat with
  | CaseBase (None, _) -> fvs
  | CaseBase (Some l, _) -> l::fvs
  | CaseCtor (_, pats) -> List.fold_left fv_pat fvs pats

let fv_pat_opt = function
  | None -> []
  | Some pat -> fv_pat [] pat

let rec fv_pe (Pexpr (_,_, e)) fvs =
  match e with
  | PEsym l -> l::fvs
  | PEimpl _ -> fvs
  | PEval _ -> fvs
  | PEconstrained cs -> List.fold_left (flip fv_pe %% snd) fvs cs
  | PEundef _ -> fvs
  | PEerror (_, pe) -> fv_pe pe fvs
  | PEctor (_, pes) -> List.fold_left (flip fv_pe) fvs pes
  | PEcase (pe, cases) ->
    List.fold_left (
      fun acc (pat, pe) -> acc@(fv_pe pe [] |> fvs_rm (fv_pat [] pat))
    ) fvs cases
    |> fv_pe pe
  | PEarray_shift (pe1, _, pe2) ->
    fv_pe pe1 fvs |> fv_pe pe2
  | PEmember_shift (pe1, l, _) -> l::(fv_pe pe1 fvs)
  | PEmemberof (l, _, pe) -> l::(fv_pe pe fvs)
  | PEnot pe -> fv_pe pe fvs
  | PEare_compatible (pe1, pe2)
  | PEop (_, pe1, pe2) ->
    fv_pe pe1 fvs |> fv_pe pe2
  | PEstruct (l,cs) -> l::(List.fold_left (flip fv_pe %% snd) fvs cs)
  | PEunion (l,_,pe) -> l::(fv_pe pe fvs)
  | PEcall (l, pes) -> List.fold_left (flip fv_pe) fvs pes
  | PElet (pat, pe1, pe2) ->
    fv_pe pe1 fvs
    |> fv_pe pe2
    |> fvs_rm (fv_pat [] pat)
  | PEif (pe1, pe2, pe3) ->
    fv_pe pe1 fvs
    |> fv_pe pe2
    |> fv_pe pe3
  | PEis_scalar pe
  | PEis_integer pe
  | PEis_signed pe
  | PEcfunction pe
  | PEis_unsigned pe -> fv_pe pe fvs

let fv_act (Paction(_, Action (_, _, act))) fvs =
  match act with
  | Create (pe1, pe2, _) -> fv_pe pe1 fvs |> fv_pe pe2
  | CreateReadOnly (pe1, pe2, pe3, _) -> fv_pe pe1 fvs |> fv_pe pe2 |> fv_pe pe3
  | Alloc0 (pe1, pe2, _) -> fv_pe pe1 fvs |> fv_pe pe2
  | Kill (_, pe) -> fv_pe pe fvs
  | Store0 (_, pe1, pe2, pe3, _) ->
    fv_pe pe1 fvs |> fv_pe pe2 |> fv_pe pe3
  | Load0 (pe1, pe2, _) -> fv_pe pe1 fvs |> fv_pe pe2
  | RMW0 (pe1, pe2, pe3, pe4, _, _) ->
    fv_pe pe1 fvs |> fv_pe pe2 |> fv_pe pe3 |> fv_pe pe4
  | Fence0 _ -> fvs

let rec fv_core (Expr (_, e_)) fvs =
  match e_ with
  | Epure pe            -> fv_pe pe fvs
  | Ememop (memop, pes) -> List.fold_left (flip fv_pe) fvs pes
  | Eaction act         -> fv_act act fvs
  | Eccall (_, _, nm, pes) -> List.fold_left (flip fv_pe) fvs (nm::pes)
  | Eproc  (_, nm, pes) -> List.fold_left (flip fv_pe) fvs pes
  | Eskip               -> fvs
  | Esave (_, ps, e) ->
    let bvs = List.map fst ps in
    let pes = List.map (snd % snd) ps in
    fv_core e (List.fold_left (flip fv_pe) fvs pes)
    |> fvs_rm bvs
  | Eif (pe1, e2, e3) ->
    fv_pe pe1 fvs
    |> fv_core e2
    |> fv_core e3
  | Ecase (pe, cases) ->
    List.fold_left (
      fun acc (pat, e) -> acc@(fvs_rm (fv_pat [] pat) (fv_core e []))
    ) fvs cases
    |> fv_pe pe
  | Ewseq (pat, e1, e2) ->
    fv_core e2 fvs
    |> fvs_rm (fv_pat [] pat)
    |> fv_core e1
  | Esseq (pat, e1, e2) ->
    fv_core e2 fvs
    |> fvs_rm (fv_pat [] pat)
    |> fv_core e1
  | Erun (_, _, pes) -> List.fold_left (flip fv_pe) fvs pes
  | Eunseq _ -> raise (Unsupported "fv unseq")
  | Ebound _ -> raise (Unsupported "fv bound")
  | End    _ -> raise (Unsupported "fv end")
  | Elet   _ -> raise (Unsupported "fv let")
  | Epar   _ -> raise (Unsupported "fv par")
  | Ewait  _ -> raise (Unsupported "fv wait")
