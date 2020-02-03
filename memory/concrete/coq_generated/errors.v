(* Generated by Lem from ocaml_generated/errors.lem. *)

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
Require Import utils.
Require Export utils.
Require Import cabs.
Require Export cabs.
Require Import ailSyntax.
Require Export ailSyntax.
Require Import core.
Require Export core.

Require Import loc.
Require Export loc.
Require Import typingError.
Require Export typingError.
Require Import undefined.
Require Export undefined.
Require Import constraint.
Require Export constraint.


Inductive misc_violation : Type := 
  | UndeclaredIdentifier:  string  -> misc_violation  (*Â§6.5.1#2 *)
  | MultipleEnumDeclaration:  cabs_identifier  -> misc_violation  (* Â§6.7.2.2#3, FOOTNOTE.127 *)
  | EnumSimpleDeclarationConstruction: misc_violation  (* Â§6.7.2.3#7, FOOTNOTE.131 *)
  | ArrayDeclarationStarIllegalScope: misc_violation  (* Â§6.7.6.2#4, sentence 2 *)
  | ArrayCharStringLiteral: misc_violation  (* Â§6.7.9#14 *)
  | UniqueVoidParameterInFunctionDeclaration: misc_violation  (* TODO: unknown quote *)
  | TypedefInitializer: misc_violation .
Definition misc_violation_default: misc_violation  := UndeclaredIdentifier string_default. (* TODO: unknown quote *)

Inductive desugar_cause : Type := 
  | Desugar_ConstraintViolation:  constraint.violation  -> desugar_cause 
  | Desugar_UndefinedBehaviour:  undefined.undefined_behaviour  -> desugar_cause 
  | Desugar_MiscViolation:  misc_violation  -> desugar_cause 
  | Desugar_NotYetSupported:  string  -> desugar_cause 
  | Desugar_NeverSupported:  string  -> desugar_cause 
  | Desugar_TODO:  string  -> desugar_cause .
Definition desugar_cause_default: desugar_cause  := Desugar_ConstraintViolation violation_default. (* TODO: get rid of this constructor eventually *)

Inductive core_typing_cause : Type := 
  | UndefinedStartup:  symbol.sym  -> core_typing_cause  (* Found no definition of the startup fun/proc *)
  | Mismatch:  string  (* syntax info *) ->  core_base_type  (* expected *) ->  core_base_type  -> core_typing_cause  (* found *)
  | MismatchBinaryOperator:  core.binop  -> core_typing_cause 
  | MismatchIf:  core_base_type  (* then *) ->  core_base_type  -> core_typing_cause  (* else *)
  | MismatchExpected:  string  (* syntax info *) ->  core_base_type  (* expected *) ->  string  -> core_typing_cause  (* found *)
  | MismatchFound:  string  (* syntax info *) ->  string  (* expected *) ->  option  core_base_type   -> core_typing_cause  (* found *)
  | UnresolvedSymbol:  name  -> core_typing_cause 
  | FunctionOrProcedureSymbol:  symbol.sym  -> core_typing_cause 
  | CFunctionExpected:  name  -> core_typing_cause  (* symbol *)
  | CFunctionParamsType: core_typing_cause 
  | CFunctionReturnType: core_typing_cause 
  | TooGeneral: core_typing_cause 
  | CoreTyping_TODO:  string  -> core_typing_cause  (* TODO: get rid of this constructor eventually *)
  (* NOTE: I cannot fire these errors *)
  | HeterogenousList:  core_base_type  (* expected *) ->  core_base_type  -> core_typing_cause  (* found *)
  | InvalidTag:  symbol.sym  -> core_typing_cause 
  | InvalidMember:  symbol.sym  ->  cabs.cabs_identifier  -> core_typing_cause .
Definition core_typing_cause_default: core_typing_cause  := UndefinedStartup sym_default.

Inductive core_linking_cause : Type := 
  | DuplicateExternalName:  cabs.cabs_identifier  -> core_linking_cause 
  | DuplicateMain: core_linking_cause .
Definition core_linking_cause_default: core_linking_cause  := DuplicateExternalName cabs_identifier_default.

Inductive core_run_cause : Type := 
  | Illformed_program:  string  -> core_run_cause  (* typing or name-scope error *)
  | Found_empty_stack:  string  -> core_run_cause  (* TODO debug *)
  | Reached_end_of_proc: core_run_cause 
  | Unknown_impl: core_run_cause 
  | Unresolved_symbol:  unit  ->  symbol.sym  -> core_run_cause .
Definition core_run_cause_default: core_run_cause  := Illformed_program string_default. (* found an unresolved symbolic name in core_eval *)

Inductive cparser_cause : Type := 
  | Cparser_invalid_symbol: cparser_cause 
  | Cparser_invalid_line_number:  string  -> cparser_cause 
  | Cparser_unexpected_eof: cparser_cause 
  | Cparser_unexpected_token:  string  -> cparser_cause 
  | Cparser_non_standard_string_concatenation: cparser_cause .
Definition cparser_cause_default: cparser_cause  := Cparser_invalid_symbol.

Inductive core_parser_cause : Type := 
  | Core_parser_invalid_symbol: core_parser_cause 
  | Core_parser_unexpected_token:  string  -> core_parser_cause 
  | Core_parser_unresolved_symbol:  string  -> core_parser_cause 
  | Core_parser_multiple_declaration:  string  -> core_parser_cause 
  | Core_parser_ctor_wrong_application:  Z  (*expected*) ->  Z  -> core_parser_cause  (* found *)
  | Core_parser_wrong_decl_in_std: core_parser_cause 
  | Core_parser_undefined_startup: core_parser_cause .
Definition core_parser_cause_default: core_parser_cause  := Core_parser_invalid_symbol.

Inductive driver_cause : Type := 
  | Driver_UB:  list  undefined.undefined_behaviour  -> driver_cause .
Definition driver_cause_default: driver_cause  := Driver_UB DAEMON.

Inductive cause : Type := 
  | CPP:  string  -> cause  (* NOTE: this is an empty string when piping to stderr *)
  | CPARSER:  cparser_cause  -> cause 
  | DESUGAR:  desugar_cause  -> cause 
  | AIL_TYPING:  typingError.typing_error  -> cause 
  | CORE_PARSER:  core_parser_cause  -> cause 
  | CORE_TYPING:  core_typing_cause  -> cause 
  | CORE_LINKING:  core_linking_cause  -> cause 
  | CORE_RUN:  core_run_cause  -> cause 
  | DRIVER:  driver_cause  -> cause 
  | UNSUPPORTED:  string  -> cause .
Definition cause_default: cause  := CPP string_default.

Definition error : Type := ( unit  * cause ) % type.
Definition error_default: error  := (unit_default, cause_default).

Instance x112_Show : Show core_run_cause := {
   show  :=  fun x =>
   match (x) with | Illformed_program str =>
     String.append "Illformed_program[" (String.append str "]")
     | Found_empty_stack str =>
     String.append "Found_empty_stack[" (String.append str "]")
     | Reached_end_of_proc => "Reached_end_of_proc" | Unknown_impl =>
     "Unknown_impl" | Unresolved_symbol _ sym1 =>
     String.append "Unresolved_symbol["
       (String.append
          match ( sym1) with symbol.Symbol0 d n str_opt =>
            String.append "Symbol"
              (stringFromPair lem_string_extra.stringFromNat
                 (fun  x_opt=>
                    stringFromMaybe
                      (fun  s=> String.append """" (String.append s """"))
                      x_opt) (n, str_opt)) end "]") end
}.

