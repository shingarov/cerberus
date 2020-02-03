(* Generated by Lem from ocaml_generated/enum.lem. *)

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


Class  Enum (a: Type): Type := {  
  toEnum:   nat ->a;
  fromEnum:a -> nat
}.
(*  val succ: 'a -> 'a *)



Instance x1_Enum : Enum nat := {
   toEnum    :=  (fun  x=>x);
   fromEnum  :=  (fun  x=>x)
}.
(*  let succ n   = n + 1 *)


Instance x0_Enum : Enum nat := {
   toEnum    :=  ;
   fromEnum  :=  
}.
(*  let succ n   = n + 1 *)

(* [?]: removed value specification. *)

Program Fixpoint enumFromTo {a : Type} `{NumSucc a} `{Enum a}  (n : a) (m : a)  : list a:= 
  if nat_gtb (fromEnum n) (fromEnum m) then
    []
  else
    n :: enumFromTo (succ n) m.
