(* Generated by Lem from ocaml_generated/TypingError.lem. *)

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

Require Import constraint.
Require Export constraint.
Require Import undefined.
Require Export undefined.


Inductive typing_misc_error : Type := 
  | UntypableIntegerConstant:  Z  -> typing_misc_error  (* Â§6.4.4.1#6, sentence 5 *)
  | ParameterTypeNotAdjusted: typing_misc_error  (* internal *)
  | VaStartArgumentType: typing_misc_error  (* Â§7.16.1.4#1 *)
  | VaArgArgumentType: typing_misc_error  (* Â§7.16.1.1#1 *)
  | GenericFunctionMustBeDirectlyCalled: typing_misc_error .
Definition typing_misc_error_default: typing_misc_error  := UntypableIntegerConstant Z_default.

Inductive typing_error : Type := 
  | TError_ConstraintViolation:  constraint.violation  -> typing_error 
  | TError_UndefinedBehaviour:  undefined.undefined_behaviour  -> typing_error 
  | TError_MiscError:  typing_misc_error  -> typing_error 
  | TError_NotYetSupported:  string  -> typing_error .
Definition typing_error_default: typing_error  := TError_ConstraintViolation violation_default.
(* [?]: removed value specification. *)

Definition std_of_typing_misc_error   : typing_misc_error  -> list (string ):=  
  fun (x : typing_misc_error ) =>
    match (x) with | UntypableIntegerConstant _ =>
      ["Â§6.4.4.1#6, sentence 5"] | ParameterTypeNotAdjusted => []
      | VaStartArgumentType => ["Â§7.16.1.4#1"; "Â§7.16#3"]
      | VaArgArgumentType => ["Â§7.16.1.1#1"; "Â§7.16#3"]
      | GenericFunctionMustBeDirectlyCalled => [] end.
(* [?]: removed value specification. *)

Definition std_of_ail_typing_error   : typing_error  -> list (string ):=  
  fun (x : typing_error ) =>
    match (x) with | TError_ConstraintViolation v =>
      constraint.std_of_violation v | TError_UndefinedBehaviour ub =>
      match ( (undefined.std_of_undefined_behaviour ub)) with | Some std =>
        [std] | None => [] end | TError_MiscError e =>
      std_of_typing_misc_error e | TError_NotYetSupported _ => [] end.

