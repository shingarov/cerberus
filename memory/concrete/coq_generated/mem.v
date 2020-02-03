(* Generated by Lem from ocaml_generated/mem.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

Require Import lem_pervasives.
Require Export lem_pervasives.

Require Import symbol.
Require Export symbol.
Require Import float.
Require Export float.
Require Import ctype.
Require Export ctype.
Require Import mem_common.
Require Export mem_common.

(* 

Inductive pointer_value : Type := .
Definition pointer_value_default: pointer_value  := DAEMON. *)
(* 
Inductive integer_value : Type := .
Definition integer_value_default: integer_value  := DAEMON. *)
(* 
Inductive floating_value : Type := .
Definition floating_value_default: floating_value  := DAEMON. *)
(*  (* BOOM *)

Inductive mem_value : Type := .
Definition mem_value_default: mem_value  := DAEMON. *) (* BOOM *)

Definition mem_iv_constraint : Type :=  mem_common.mem_constraint  tt .
Definition mem_iv_constraint_default: mem_iv_constraint  := DAEMON.


Instance x62_Show : Show tt := {
   show   ptrval :=  "TODO"
}.

Instance x61_Show : Show tt := {
   show   mval :=  "TODO"
}.

(* 


(* This abstract in returns by memory actions and two footprints can be checked for overlapping.
   They are in particular useful to detect races. *)
Inductive footprint : Type := .
Definition footprint_default: footprint  := DAEMON. *)
(* [?]: removed value specification. *)



Inductive mem_state : Type := .
Definition mem_state_default: mem_state  := DAEMON.
(* [?]: removed value specification. *)



Definition memM (a: Type) : Type := 
  nondeterminism.ndM  a  string   mem_common.mem_error   (mem_common.mem_constraint  tt )  mem_state .
Definition memM_default{a: Type} : memM a := DAEMON.
(* [?]: removed value specification. *)

(* [?]: removed top-level value definition. *)
(* [?]: removed value specification. *)

(* [?]: removed top-level value definition. *)
(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

