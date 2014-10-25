%{
open Cabs

let id =
  fun z -> z

let option d f = function
  | Some z -> f z
  | None   -> d


let empty_specs = {
  storage_classes= [];
  type_specifiers= [];
  type_qualifiers= [];
  function_specifiers= [];
  alignment_specifiers= [];
}


(* TODO: debug *)
let dummy_loc =
  let p = {
    Lexing.pos_fname= "hello.c";
    Lexing.pos_lnum=  42;
    Lexing.pos_bol=   120;
    Lexing.pos_cnum=  120;
  } in
  (p, p)

%}


(* §6.4.1 keywords *)
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN
  FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF
  STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE ALIGNAS
  ALIGNOF ATOMIC BOOL COMPLEX GENERIC (* IMAGINARY *) NORETURN STATIC_ASSERT
  THREAD_LOCAL
  ATOMIC_LPAREN (* this is a hack to solve a grammar ambiguity (see Lexer.mll) *)

(* §6.4.2 Identifiers *)
%token<Cabs.cabs_identifier> VAR_NAME2 TYPEDEF_NAME2 OTHER_NAME

(* §6.4.4 Constants *)
%token<Cabs.cabs_constant> CONSTANT

(* §6.4.5 String literals *)
%token<Cabs.cabs_string_literal> STRING_LITERAL

(* §6.4.6 Punctuators *)
%token LBRACKET RBRACKET LPAREN RPAREN LBRACE RBRACE DOT MINUS_GT
  PLUS_PLUS MINUS_MINUS AMPERSAND STAR PLUS MINUS TILDE BANG
  SLASH PERCENT LT_LT GT_GT LT GT LT_EQ GT_EQ EQ_EQ BANG_EQ CARET PIPE AMPERSAND_AMPERSAND PIPE_PIPE
  QUESTION COLON SEMICOLON ELLIPSIS
  EQ STAR_EQ SLASH_EQ PERCENT_EQ PLUS_EQ MINUS_EQ LT_LT_EQ GT_GT_EQ AMPERSAND_EQ CARET_EQ PIPE_EQ
  COMMA (* TODO: HASH HASH_HASH *)
(* TODO(in lexer?)  LT_COLON COLON_GT LT_PERCENT PERCENT_GT PERCENT_COLON PERCENT_COLON_PERCENT_COLON *)

%token EOF

(* ========================================================================== *)

%type<Cabs.cabs_identifier>
  enumeration_constant

%type<Cabs.cabs_expression>
  primary_expression generic_selection postfix_expression unary_expression
  cast_expression multiplicative_expression additive_expression shift_expression
  relational_expression equality_expression _AND_expression
  exclusive_OR_expression inclusive_OR_expression logical_AND_expression
  logical_OR_expression conditional_expression assignment_expression expression
  constant_expression

%type<Cabs.cabs_generic_association list>
  generic_assoc_list
%type<Cabs.cabs_generic_association>
  generic_association

%type<Cabs.cabs_expression list>
  argument_expression_list

%type<Cabs.cabs_unary_operator>
  unary_operator
%type<Cabs.cabs_assignment_operator>
  assignment_operator

%type<Cabs.declaration>
  declaration

%type<Cabs.specifiers>
  declaration_specifiers

%type<Cabs.init_declarator list>
  init_declarator_list

%type<Cabs.init_declarator>
  init_declarator

%type<Cabs.storage_class_specifier>
  storage_class_specifier

%type<Cabs.cabs_type_specifier>
  type_specifier

%type<Cabs.cabs_type_specifier>
  struct_or_union_specifier

%type<Cabs.cabs_identifier option -> (Cabs.struct_declaration list) option -> Cabs.cabs_type_specifier>
  struct_or_union

%type<Cabs.struct_declaration list>
  struct_declaration_list

%type<Cabs.struct_declaration>
  struct_declaration

%type<Cabs.cabs_type_specifier list * Cabs.cabs_type_qualifier list>
  specifier_qualifier_list

%type<Cabs.struct_declarator list>
  struct_declarator_list

%type<Cabs.struct_declarator>
  struct_declarator

%type<Cabs.cabs_type_specifier>
  enum_specifier

%type<Cabs.enumerator list>
  enumerator_list

%type<Cabs.enumerator>
  enumerator

%type<Cabs.cabs_type_specifier>
  atomic_type_specifier

%type<Cabs.cabs_type_qualifier>
  type_qualifier

%type<Cabs.function_specifier>
  function_specifier

%type<Cabs.alignment_specifier>
  alignment_specifier

%type<Cabs.declarator>
  declarator

%type<Cabs.direct_declarator>
  direct_declarator

%type<Cabs.pointer_declarator>
  pointer

%type<Cabs.cabs_type_qualifier list>
  type_qualifier_list

%type<Cabs.parameter_type_list>
  parameter_type_list

%type<Cabs.parameter_declaration list>
  parameter_list

%type<Cabs.parameter_declaration>
  parameter_declaration

%type<Cabs.type_name>
  type_name

%type<Cabs.abstract_declarator>
  abstract_declarator

%type<Cabs.direct_abstract_declarator>
  direct_abstract_declarator

%type<Cabs.initializer_>
  initializer_

%type<((Cabs.designator list) option * Cabs.initializer_) list>
  initializer_list

%type<Cabs.designator list>
  designation

%type<Cabs.designator list>
  designator_list

%type<Cabs.designator>
  designator

%type<Cabs.static_assert_declaration>
  static_assert_declaration

%type<Cabs.cabs_statement>
  statement_dangerous statement_safe  labeled_statement(statement_safe)
  labeled_statement(statement_dangerous) iteration_statement(statement_safe)
  iteration_statement(statement_dangerous) compound_statement
  expression_statement selection_statement_dangerous selection_statement_safe
  iteration_statement(last_statement) jump_statement

%type<Cabs.cabs_statement list>
  block_item_list

%type<Cabs.cabs_statement>
  block_item

%type<Cabs.external_declaration list>
  translation_unit

%type<Cabs.external_declaration>
  external_declaration

%type<Cabs.function_definition>
  function_definition





%start<Cabs.translation_unit> translation_unit_file

%% (* ======================================================================= *)

translation_unit_file: (* NOTE: this is not present in the standard *)
| edecls= translation_unit EOF
    { TUnit (List.rev edecls) }







(* §6.4.4.3 Enumeration constants Primary expressions *)
enumeration_constant:
| cst= VAR_NAME2
    { cst }


(* §6.5.1 Primary expressions *)
primary_expression:
| id= VAR_NAME2
    { CabsExpression (($startpos, $endpos), CabsEident id) }
| cst= CONSTANT
    { CabsExpression (($startpos, $endpos), CabsEconst cst) }
| lit= STRING_LITERAL
    { CabsExpression (($startpos, $endpos), CabsEstring lit) }
| LPAREN expr= expression RPAREN
    { expr }
| gs= generic_selection
    { gs }


(* §6.5.1.1 Generic selection *)
generic_selection:
| GENERIC LPAREN expr= assignment_expression COMMA gas= generic_assoc_list RPAREN
    { CabsExpression (($startpos, $endpos), CabsEgeneric (expr, gas)) }

generic_assoc_list: (* NOTE: the list is in reverse *)
| ga= generic_association
    { [ga] }
| gas= generic_assoc_list COMMA ga= generic_association
    { ga::gas }

generic_association:
| ty= type_name COLON expr= assignment_expression
    { GA_type (ty, expr) }
| DEFAULT COLON expr= assignment_expression
    { GA_default expr }


(* §6.5.2 Postfix operators *)
postfix_expression:
| expr= primary_expression
    { expr }
| expr1= postfix_expression LBRACKET expr2= expression RBRACKET
    { CabsExpression (($startpos, $endpos), CabsEsubscript (expr1, expr2)) }
| expr= postfix_expression LPAREN exprs_opt= argument_expression_list? RPAREN
    { CabsExpression (($startpos, $endpos), CabsEcall (expr, option [] List.rev exprs_opt)) }
| expr= postfix_expression DOT id= OTHER_NAME
    { CabsExpression (($startpos, $endpos), CabsEmemberof (expr, id)) }
| expr= postfix_expression MINUS_GT id= OTHER_NAME
    { CabsExpression (($startpos, $endpos), CabsEmemberofptr (expr, id)) }
| expr= postfix_expression PLUS_PLUS
    { CabsExpression (($startpos, $endpos), CabsEpostincr expr) }
| expr= postfix_expression MINUS_MINUS
    { CabsExpression (($startpos, $endpos), CabsEpostdecr expr) }
| LPAREN ty= type_name RPAREN LBRACE inits= initializer_list RBRACE
| LPAREN ty= type_name RPAREN LBRACE inits= initializer_list COMMA RBRACE
    { CabsExpression (($startpos, $endpos), CabsEcompound (ty, List.rev inits)) }

argument_expression_list: (* NOTE: the list is in reverse *)
| expr= assignment_expression
    { [expr] }
| exprs= argument_expression_list COMMA expr= assignment_expression
    { expr::exprs }


(* §6.5.3 Unary operators *)
unary_expression:
| expr= postfix_expression
    { expr }
| PLUS_PLUS expr= unary_expression
    { CabsExpression (($startpos, $endpos), CabsEpreincr expr) }
| MINUS_MINUS expr= unary_expression
    { CabsExpression (($startpos, $endpos), CabsEpredecr expr) }
| op= unary_operator expr= cast_expression
    { CabsExpression (($startpos, $endpos), CabsEunary (op, expr)) }
| SIZEOF expr= unary_expression
    { CabsExpression (($startpos, $endpos), CabsEsizeof_expr expr) }
| SIZEOF LPAREN ty= type_name RPAREN
    { CabsExpression (($startpos, $endpos), CabsEsizeof_type ty) }
| ALIGNOF LPAREN ty= type_name RPAREN
    { CabsExpression (($startpos, $endpos), CabsEalignof ty) }

unary_operator:
| AMPERSAND
    { CabsAddress }
| STAR
    { CabsIndirection }
| PLUS
    { CabsPlus }
| MINUS
    { CabsMinus }
| TILDE
    { CabsBnot }
| BANG
    { CabsNot }


(* §6.5.4 Cast operators *)
cast_expression:
| expr= unary_expression
    { expr }
| LPAREN ty= type_name RPAREN expr= cast_expression
    { CabsExpression (($startpos, $endpos), CabsEcast (ty, expr)) }


(* §6.5.5 Multiplicative operators *)
multiplicative_expression:
| expr= cast_expression
    { expr }
| expr1= multiplicative_expression STAR expr2= cast_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsMul, expr1, expr2)) }
| expr1= multiplicative_expression SLASH expr2= cast_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsDiv, expr1, expr2)) }
| expr1= multiplicative_expression PERCENT expr2= cast_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsMod, expr1, expr2)) }


(* §6.5.6 Additive operators *)
additive_expression:
| expr= multiplicative_expression
    { expr }
| expr1= additive_expression PLUS expr2= multiplicative_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsAdd, expr1, expr2)) }
| expr1= additive_expression MINUS expr2= multiplicative_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsSub, expr1, expr2)) }


(* §6.5.7 Bitwise shift operators *)
shift_expression:
| expr= additive_expression
    { expr }
| expr1= shift_expression LT_LT expr2= additive_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsShl, expr1, expr2)) }
| expr1= shift_expression GT_GT expr2= additive_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsShr, expr1, expr2)) }


(* §6.5.8 Relational operators *)
relational_expression:
| expr= shift_expression
    { expr }
| expr1= relational_expression LT expr2= shift_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsLt, expr1, expr2)) }
| expr1= relational_expression GT expr2= shift_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsGt, expr1, expr2)) }
| expr1= relational_expression LT_EQ expr2= shift_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsLe, expr1, expr2)) }
| expr1= relational_expression GT_EQ expr2= shift_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsGe, expr1, expr2)) }


(* §6.5.9 Equality operators *)
equality_expression:
| expr= relational_expression
    { expr }
| expr1= equality_expression EQ_EQ expr2= relational_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsEq, expr1, expr2)) }
| expr1= equality_expression BANG_EQ expr2= relational_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsNe, expr1, expr2)) }


(* §6.5.10 Bitwise AND operator *)
_AND_expression:
| expr= equality_expression
    { expr }
| expr1= _AND_expression AMPERSAND expr2= equality_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsBand, expr1, expr2)) }


(* §6.5.11 Bitwise exclusive OR operator *)
exclusive_OR_expression:
| expr= _AND_expression
    { expr }
| expr1= exclusive_OR_expression CARET expr2= _AND_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsBxor, expr1, expr2)) }


(* §6.5.12 Bitwise inclusive OR operator *)
inclusive_OR_expression:
| expr= exclusive_OR_expression
    { expr }
| expr1= inclusive_OR_expression PIPE expr2= exclusive_OR_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsBor, expr1, expr2)) }


(* §6.5.13 Logical AND operator *)
logical_AND_expression:
| expr= inclusive_OR_expression
    { expr }
| expr1= logical_AND_expression AMPERSAND_AMPERSAND expr2= inclusive_OR_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsAnd, expr1, expr2)) }


(* §6.5.14 Logical OR operator *)
logical_OR_expression:
| expr= logical_AND_expression
    { expr }
| expr1= logical_OR_expression PIPE_PIPE expr2= logical_AND_expression
    { CabsExpression (($startpos, $endpos), CabsEbinary (CabsOr, expr1, expr2)) }


(* §6.5.15 Conditional operator *)
conditional_expression:
| expr= logical_OR_expression
    { expr }
| expr1= logical_OR_expression QUESTION expr2= expression COLON expr3= conditional_expression
    { CabsExpression (($startpos, $endpos), CabsEcond (expr1, expr2, expr3)) }


(* §6.5.16 Assignment operators *)
assignment_expression:
| expr= conditional_expression
    { expr }
| expr1= unary_expression op= assignment_operator expr2= assignment_expression
    { CabsExpression (($startpos, $endpos), CabsEassign (op, expr1, expr2)) }

assignment_operator:
| EQ
    { Assign  }
| STAR_EQ
    { Assign_Mul }
| SLASH_EQ
    { Assign_Div }
| PERCENT_EQ
    { Assign_Mod }
| PLUS_EQ
    { Assign_Add }
| MINUS_EQ
    { Assign_Sub }
| LT_LT_EQ
    { Assign_Shl }
| GT_GT_EQ
    { Assign_Shr }
| AMPERSAND_EQ
    { Assign_Band }
| CARET_EQ
    { Assign_Bxor }
| PIPE_EQ
    { Assign_Bor }


(* §6.5.17 Comma operator *)
expression:
| expr= assignment_expression
    { expr }
| expr1= expression COMMA expr2= assignment_expression
    { CabsExpression (($startpos, $endpos), CabsEcomma (expr1, expr2)) }


(* §6.6 Constant expressions *)
constant_expression:
| expr= conditional_expression
    { expr }


(* §6.7 Declarations *)
declaration:
| decspecs= declaration_specifiers idecls_opt= init_declarator_list? SEMICOLON
    { Declaration_base (decspecs, option [] id idecls_opt) }
| sa= static_assert_declaration
    { Declaration_static_assert sa }

declaration_specifiers:
| sc= storage_class_specifier specs_opt= declaration_specifiers?
    { let specs = option empty_specs id specs_opt in
      { specs with storage_classes= sc :: specs.storage_classes }
    }
| tspec= type_specifier specs_opt= declaration_specifiers?
    { let specs = option empty_specs id specs_opt in
      { specs with type_specifiers= tspec :: specs.type_specifiers }
    }
| tqual= type_qualifier specs_opt= declaration_specifiers?
    { let specs = option empty_specs id specs_opt in
      { specs with type_qualifiers= tqual :: specs.type_qualifiers }
    }
| fspec= function_specifier specs_opt= declaration_specifiers?
    { let specs = option empty_specs id specs_opt in
      { specs with function_specifiers= fspec :: specs.function_specifiers }
    }
| aspec= alignment_specifier specs_opt= declaration_specifiers?
    { let specs = option empty_specs id specs_opt in
      { specs with alignment_specifiers= aspec :: specs.alignment_specifiers }
    }

init_declarator_list: (* NOTE: the list is in reverse *)
| idecl= init_declarator
    { [idecl] }
| idecls= init_declarator_list COMMA idecl= init_declarator
    { idecl::idecls }

init_declarator:
| decl= declarator
    { InitDecl (decl, None) }
| decl= declarator EQ init= initializer_
    { InitDecl (decl, Some init) }


(* §6.7.1 Storage-class specifiers *)
storage_class_specifier:
| TYPEDEF
    { SC_typedef }
| EXTERN
    { SC_extern }
| STATIC
    { SC_static }
| THREAD_LOCAL
    { SC_Thread_local }
| AUTO
    { SC_auto }
| REGISTER
    { SC_register }


(* §6.7.2 Type specifiers *)
type_specifier:
| VOID
    { TSpec_void }
| CHAR
    { TSpec_char }
| SHORT
    { TSpec_short }
| INT
    { TSpec_int }
| LONG
    { TSpec_long }
| FLOAT
    { TSpec_float }
| DOUBLE
    { TSpec_double }
| SIGNED
    { TSpec_signed }
| UNSIGNED
    { TSpec_unsigned }
| BOOL
    { TSpec_Bool }
| COMPLEX
    { TSpec_Complex }
| spec= atomic_type_specifier
    { spec }
| spec= struct_or_union_specifier
    { spec }
| spec= enum_specifier
    { spec }
| id= TYPEDEF_NAME2
    { TSpec_name id }


(* §6.7.2.1 Structure and union specifiers *)
struct_or_union_specifier:
| ctor= struct_or_union id_opt= OTHER_NAME? LBRACE decls= struct_declaration_list RBRACE
    {  ctor id_opt (Some (List.rev decls)) }
| ctor= struct_or_union id= OTHER_NAME
    { ctor (Some id) None }

struct_or_union:
| STRUCT
    { fun x y -> TSpec_struct (x, y) }
| UNION
    { fun x y -> TSpec_union (x, y) }

struct_declaration_list: (* NOTE: the list is in reverse *)
| sdecl= struct_declaration
    { [sdecl] }
| sdecls= struct_declaration_list sdecl= struct_declaration
    { sdecl::sdecls }

struct_declaration:
| tspecs_tquals= specifier_qualifier_list sdeclrs_opt= struct_declarator_list? SEMICOLON
    { let (tspecs, tquals) = tspecs_tquals in Struct_declaration (tspecs, tquals, option [] id sdeclrs_opt) }
| sa_decl= static_assert_declaration
    { Struct_assert sa_decl }

specifier_qualifier_list:
| tspec= type_specifier tspecs_tquals_opt= specifier_qualifier_list?
    {
      let (tspecs, tquals) = option ([],[]) id tspecs_tquals_opt in
      (tspec::tspecs, tquals)
    }
| tqual= type_qualifier tspecs_tquals_opt= specifier_qualifier_list?
    {
      let (tspecs, tquals) = option ([],[]) id tspecs_tquals_opt in
      (tspecs, tqual::tquals)
    }

struct_declarator_list: (* NOTE: the list is in reverse *)
| sdelctor= struct_declarator
    { [sdelctor] }

| sdecltors= struct_declarator_list COMMA sdecltor= struct_declarator
    { sdecltor::sdecltors }

struct_declarator:
| decltor= declarator
    { SDecl_simple decltor }
| decltor_opt= declarator? COLON expr= constant_expression
    { SDecl_bitfield (decltor_opt, expr) }


(* §6.7.2.2 Enumeration specifiers *)
enum_specifier:
| ENUM id_opt= OTHER_NAME? LBRACE enums= enumerator_list RBRACE
| ENUM id_opt= OTHER_NAME? LBRACE enums= enumerator_list COMMA RBRACE
    { TSpec_enum (id_opt, Some (List.rev enums)) }
| ENUM id= OTHER_NAME
    { TSpec_enum (Some id, None)  }

enumerator_list: (* NOTE: the list is in reverse *)
| enum= enumerator
    { [enum] }
| enums= enumerator_list COMMA enum= enumerator
    { enum::enums }

enumerator:
| enum_cst= enumeration_constant
    { (enum_cst, None) }
| enum_cst= enumeration_constant EQ expr= constant_expression
    { (enum_cst, Some expr) }


(* §6.7.2.4 Atomic type specifiers *)
atomic_type_specifier:
| ATOMIC_LPAREN ty= type_name RPAREN
    { TSpec_Atomic ty }


(* §6.7.3 Type qualifiers *)
type_qualifier:
| CONST
    { Q_const }
| RESTRICT
    { Q_restrict }
| VOLATILE
    { Q_volatile }
| ATOMIC
    { Q_Atomic }


(* §6.7.4 Function specifiers *)
function_specifier:
| INLINE
    { FS_inline }
| NORETURN
    { FS_Noreturn }


(* §6.7.5 Alignment specifier *)
alignment_specifier:
| ALIGNAS LPAREN ty= type_name RPAREN
    { AS_type ty }
| ALIGNAS LPAREN expr= constant_expression RPAREN
    { AS_expr expr }


(* §6.7.6 Declarators *)
declarator:
| ptr_opt= pointer? ddecltor= direct_declarator
    { Declarator (ptr_opt, ddecltor) }

direct_declarator:
| id= VAR_NAME2
    { DDecl_identifier id }
| LPAREN decltor= declarator RPAREN
    { DDecl_declarator decltor }
| ddecltor= direct_declarator LBRACKET tquals_opt= type_qualifier_list? expr_opt= assignment_expression? RBRACKET
    { DDecl_array (ddecltor, ADecl (($startpos, $endpos), option [] List.rev tquals_opt, false, option None (fun z -> Some (ADeclSize_expression z)) expr_opt)) }
| ddecltor= direct_declarator LBRACKET STATIC tquals_opt= type_qualifier_list? expr= assignment_expression RBRACKET
    { DDecl_array (ddecltor, ADecl (dummy_loc, option [] List.rev tquals_opt, true, Some (ADeclSize_expression expr))) }
| ddecltor= direct_declarator LBRACKET tquals= type_qualifier_list STATIC expr= assignment_expression RBRACKET
    { DDecl_array (ddecltor, ADecl (dummy_loc, List.rev tquals, true, Some (ADeclSize_expression expr))) }
| ddecltor= direct_declarator LBRACKET tquals_opt= type_qualifier_list? STAR RBRACKET
    { DDecl_array (ddecltor, ADecl (dummy_loc, option [] List.rev tquals_opt, false, Some ADeclSize_asterisk)) }
| ddecltor= direct_declarator LPAREN param_tys= parameter_type_list RPAREN
    { DDecl_function (ddecltor, param_tys) }
(* TODO this is hack, while we don't support identifier_list *)
| ddecltor= direct_declarator LPAREN RPAREN
    { DDecl_function (ddecltor, Params ([], false)) }
(* TODO | direct_declarator LPAREN identifier_list? RPAREN *)

pointer:
| STAR tquals= type_qualifier_list?
    { PDecl (option [] List.rev tquals, None) }
| STAR tquals= type_qualifier_list? ptr_decltor= pointer
    { PDecl (option [] List.rev tquals, Some ptr_decltor) }

type_qualifier_list: (* NOTE: the list is in reverse *)
| tqual= type_qualifier
    { [tqual] }
| tquals= type_qualifier_list tqual= type_qualifier
    { tqual::tquals }

parameter_type_list:
| param_decls= parameter_list
    { Params (List.rev param_decls, false) }
| param_decls= parameter_list COMMA ELLIPSIS
    { Params (List.rev param_decls, true) }

parameter_list: (* NOTE: the list is in reverse *)
| param_decl= parameter_declaration
    { [param_decl] }
| param_decls= parameter_list COMMA param_decl= parameter_declaration
    { param_decl::param_decls }

parameter_declaration:
| specifs= declaration_specifiers decltor= declarator
    { PDeclaration_decl (specifs, decltor) }
| specifs= declaration_specifiers abs_decltor_opt= abstract_declarator?
    { PDeclaration_abs_decl (specifs, abs_decltor_opt) }

(* TODO
identifier_list:
| identifier
| identifier_list COMMA identifier
    { failwith "TODO: identifier_list" }
*)


(* §6.7.7 Type names *)
type_name:
| tspecs_tquals= specifier_qualifier_list abs_declr_opt= abstract_declarator?
    { let (tspecs, tquals) = tspecs_tquals in
      Type_name (tspecs, tquals, abs_declr_opt) }

abstract_declarator:
| ptr_decltor= pointer
    { AbsDecl_pointer ptr_decltor }
| ptr_decltor_opt= pointer? dabs_decltor= direct_abstract_declarator
    { AbsDecl_direct (ptr_decltor_opt, dabs_decltor) }

 (* NOTE: this rule is split to avoid a conflict *)
direct_abstract_declarator:
| LPAREN abs_decltor= abstract_declarator RPAREN
    { DAbs_abs_declarator abs_decltor }
(* direct_abstract_declarator? LBRACKET type_qualifier_list? assignment_expression? RBRACKET *)
| dabs_decltor= direct_abstract_declarator LBRACKET tquals= type_qualifier_list expr= assignment_expression RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, tquals, false, Some (ADeclSize_expression expr))) }
| dabs_decltor= direct_abstract_declarator LBRACKET tquals= type_qualifier_list RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, tquals, false, None)) }
| dabs_decltor= direct_abstract_declarator LBRACKET expr= assignment_expression RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, [], false, Some (ADeclSize_expression expr))) }
| dabs_decltor= direct_abstract_declarator LBRACKET RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, [], false, None)) }
| LBRACKET tquals= type_qualifier_list expr= assignment_expression RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, tquals, false, Some (ADeclSize_expression expr))) }
| LBRACKET expr= assignment_expression RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, [], false, Some (ADeclSize_expression expr))) }
| LBRACKET tquals= type_qualifier_list RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, tquals, false, None)) }
| LBRACKET RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, [], false, None)) }
(* direct_abstract_declarator? LBRACKET STATIC type_qualifier_list? assignment_expression RBRACKET *)
| dabs_decltor= direct_abstract_declarator LBRACKET STATIC tquals= type_qualifier_list expr= assignment_expression RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, tquals, true, Some (ADeclSize_expression expr))) }
| LBRACKET STATIC tquals= type_qualifier_list expr= assignment_expression RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, tquals, true, Some (ADeclSize_expression expr))) }
| dabs_decltor= direct_abstract_declarator LBRACKET STATIC expr= assignment_expression RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, [], true, Some (ADeclSize_expression expr))) }
| LBRACKET STATIC expr= assignment_expression RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, [], true, Some (ADeclSize_expression expr))) }
(* direct_abstract_declarator? LBRACKET type_qualifier_list STATIC assignment_expression RBRACKET *)
| dabs_decltor= direct_abstract_declarator LBRACKET tquals= type_qualifier_list STATIC expr= assignment_expression RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, tquals, true, Some (ADeclSize_expression expr))) }
| LBRACKET tquals= type_qualifier_list STATIC expr= assignment_expression RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, tquals, true, Some (ADeclSize_expression expr))) }
(* direct_abstract_declarator? LBRACKET STAR RBRACKET *)
| dabs_decltor= direct_abstract_declarator LBRACKET STAR RBRACKET
    { DAbs_array (Some dabs_decltor, ADecl (dummy_loc, [], false, Some ADeclSize_asterisk)) }
| LBRACKET STAR RBRACKET
    { DAbs_array (None, ADecl (dummy_loc, [], false, Some ADeclSize_asterisk)) }
(* direct_abstract_declarator? LPAREN parameter_type_list? RPAREN *)
| dabs_decltor= direct_abstract_declarator LPAREN param_tys_opt= parameter_type_list? RPAREN
    { DAbs_function (Some dabs_decltor, option (Params ([], false)) (fun z -> z) param_tys_opt) }
| LPAREN param_tys_opt= parameter_type_list? RPAREN
    { DAbs_function (None, option (Params ([], false)) (fun z -> z) param_tys_opt) }


(* §6.7.8 Type definitions
  
  NOTE: This is dealt with during the pre parsing and appear
        here as the token TYPEDEF_NAME2
*)


(* §6.7.9 Initialization *)
initializer_:
| expr= assignment_expression
    { Init_expr expr }
| LBRACE inits= initializer_list RBRACE
| LBRACE inits= initializer_list COMMA RBRACE
    { Init_list (List.rev inits) }

initializer_list: (* NOTE: the list is in reverse *)
| design_opt= designation? init= initializer_
    { [(design_opt, init)] }
| inits= initializer_list COMMA design_opt= designation? init= initializer_
    { (design_opt, init)::inits }

designation:
| design= designator_list EQ
    { List.rev design }

designator_list: (* NOTE: the list is in reverse *)
| design= designator
    { [design] }
| designs= designator_list design= designator
    { design::designs }

designator:
| LBRACKET expr= constant_expression RBRACKET
    { Desig_array expr }
| DOT id= OTHER_NAME
    { Desig_member id }


(* §6.7.10 Static assertions *)
static_assert_declaration:
| STATIC_ASSERT LPAREN expr= constant_expression COMMA lit= STRING_LITERAL RPAREN SEMICOLON
    { Static_assert (expr, lit) }


(* §6.8 Statements and blocks *)
statement_dangerous:
| stmt= labeled_statement(statement_dangerous)
| stmt= compound_statement
| stmt= expression_statement
| stmt= selection_statement_dangerous
| stmt= iteration_statement(statement_dangerous)
| stmt= jump_statement
    { stmt }

statement_safe:
| stmt= labeled_statement(statement_safe)
| stmt= compound_statement
| stmt= expression_statement
| stmt= selection_statement_safe
| stmt= iteration_statement(statement_safe)
| stmt= jump_statement
    { stmt }


(* §6.8.1 Labeled statements *)
labeled_statement(last_statement):
| id= OTHER_NAME COLON stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsSlabel (id, stmt)) }
| CASE expr= constant_expression COLON stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsScase (expr, stmt)) }
| DEFAULT COLON stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsSdefault stmt) }


(* §6.8.2 Compound statement *)
compound_statement:
| LBRACE bis_opt= block_item_list? RBRACE
    { CabsStatement (($startpos, $endpos), CabsSblock (option [] List.rev bis_opt)) }

block_item_list: (* NOTE: the list is in reverse *)
| stmt= block_item
    { [stmt] }
| stmts= block_item_list stmt= block_item
    { stmt::stmts }

block_item:
| decl= declaration
    { CabsStatement (($startpos, $endpos), CabsSdecl decl) }
| stmt= statement_dangerous
    { stmt }


(* §6.8.3 Expression and null statements *)
expression_statement:
| expr_opt= expression? SEMICOLON
    { CabsStatement (($startpos, $endpos), option CabsSnull (fun z -> CabsSexpr z) expr_opt) }


(* §6.8.4 Selection statements *)
selection_statement_dangerous:
| IF LPAREN expr= expression RPAREN stmt= statement_dangerous
    { CabsStatement (($startpos, $endpos), CabsSif (expr, stmt, None)) }
| IF LPAREN expr= expression RPAREN stmt1= statement_safe ELSE stmt2= statement_dangerous
    { CabsStatement (($startpos, $endpos), CabsSif (expr, stmt1, Some stmt2)) }
| SWITCH LPAREN expr= expression RPAREN stmt= statement_dangerous
    { CabsStatement (($startpos, $endpos), CabsSswitch (expr, stmt)) }

selection_statement_safe:
| IF LPAREN expr= expression RPAREN stmt1= statement_safe ELSE stmt2= statement_safe
    { CabsStatement (($startpos, $endpos), CabsSif (expr, stmt1, Some stmt2)) }
| SWITCH LPAREN expr= expression RPAREN stmt= statement_safe
    { CabsStatement (($startpos, $endpos), CabsSswitch (expr, stmt)) }


(* §6.8.5 Iteration statements *)
iteration_statement(last_statement):
| WHILE LPAREN expr= expression RPAREN stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsSwhile (expr, stmt)) }
| DO stmt= statement_dangerous WHILE LPAREN expr= expression RPAREN SEMICOLON
    { CabsStatement (($startpos, $endpos), CabsSdo (expr, stmt)) }
| FOR LPAREN expr1_opt= expression? SEMICOLON expr2_opt= expression? SEMICOLON expr3_opt= expression? RPAREN stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsSfor (option None (fun z -> Some (FC_expr z)) expr1_opt, expr2_opt, expr3_opt, stmt)) }
| FOR LPAREN decl= declaration expr2_opt= expression? SEMICOLON expr3_opt= expression? RPAREN stmt= last_statement
    { CabsStatement (($startpos, $endpos), CabsSfor (Some (FC_decl decl), expr2_opt, expr3_opt, stmt)) }


(* §6.8.6 Jump statements *)
jump_statement:
| GOTO id= OTHER_NAME SEMICOLON
    { CabsStatement (($startpos, $endpos), CabsSgoto id) }
| CONTINUE SEMICOLON
    { CabsStatement (($startpos, $endpos), CabsScontinue) }
| BREAK SEMICOLON
    { CabsStatement (($startpos, $endpos), CabsSbreak) }
| RETURN expr_opt= expression? SEMICOLON
    { CabsStatement (($startpos, $endpos), CabsSreturn expr_opt) }


(* §6.9 External definitions *)
translation_unit: (* NOTE: the list is in reverse *)
| def= external_declaration
    { [def] }
| defs = translation_unit def= external_declaration
    { def :: defs }

external_declaration:
| fdef= function_definition
    { EDecl_func fdef }
| decl= declaration
    { EDecl_decl decl }


(* §6.9.1 Function definitions *)
(* TODO: declaration_list (this is old K&R ??) *)
function_definition:
| specifs= declaration_specifiers decltor= declarator stmt= compound_statement
    { FunDef (specifs, decltor, stmt) }
