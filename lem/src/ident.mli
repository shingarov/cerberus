(* t is the type of dot separated lists of names (with preceding lexical
 * spacing), e.g. '(*Foo*) M . x' *)
type t

(* Pretty print *)
val pp : Format.formatter -> t -> unit

val from_id : Ast.id -> t

(* Return the last name in the ident, e.g., M.Y.x gives x *)
val get_name : t -> Name.lskips_t

val mk_ident : Name.lskips_t list -> Name.lskips_t -> t
val mk_ident_skips : (Name.lskips_t * Ast.lex_skips) list -> Name.lskips_t -> t
val to_output : Output.id_annot -> Output.t -> t -> Output.t
val get_first_lskip: t -> Ast.lex_skips
val drop_parens : (Precedence.op -> Precedence.t) -> t -> t
val add_parens : (Precedence.op -> Precedence.t) -> t -> t
(*
val starts_with_upper_letter : t -> bool
val starts_with_lower_letter : t -> bool
val capitalize : t -> t
val uncapitalize : t -> t
 *)
val replace_first_lskip : t -> Ast.lex_skips -> t
val get_prec : (Precedence.op -> Precedence.t) -> t -> Precedence.t
val to_name_list : t -> Name.t list * Name.t
