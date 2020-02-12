(* Generated by Lem from ocaml_generated/annot.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

Require Import lem_maybe.
Require Export lem_maybe.

Require Import lem_pervasives.
Require Export lem_pervasives.

Require Import loc.
Require Export loc.

Require Import symbol.
Require Export symbol.


Inductive bmc_annot : Type := 
  | Abmc_id:  nat  -> bmc_annot .
Definition bmc_annot_default: bmc_annot  := Abmc_id nat_default. (* NOTE: basically same as uid *)

Inductive annot : Type := 
  | Astd:  string  -> annot  (* ISO C11 Standard Annotation *)
  | Aloc:  unit  -> annot  (* C source location *)
  | Auid:  string  -> annot  (* Unique ID *)
  | Abmc:  bmc_annot  -> annot .
Definition annot_default: annot  := Astd string_default.
(* [?]: removed value specification. *)

Program Fixpoint get_loc  (annots1 : list (annot ))  : option (unit ) := 
  match ( annots1) with 
    | [] =>
        None
    |( Aloc loc :: _) =>
        Some loc
    |( Astd _ :: annots') =>
        get_loc annots'
    |( Auid _ :: annots') =>
        get_loc annots'
    |( Abmc _ :: annots') =>
        get_loc annots'
  end.
(* [?]: removed value specification. *)

Definition get_loc_  (annots1 : list (annot ))  : unit := 
  match ( get_loc annots1) with 
    | Some loc => loc
    | None => tt
  end.
(* [?]: removed value specification. *)

Program Fixpoint get_uid  (annots1 : list (annot ))  : option (string ) := 
  match ( annots1) with 
    | [] =>
        None
    |( Aloc _ :: annots') =>
        get_uid annots'
    |( Astd _ :: annots') =>
        get_uid annots'
    |( Auid uid :: _) =>
        Some uid
    |( Abmc _ :: annots') =>
        get_uid annots'
  end.

