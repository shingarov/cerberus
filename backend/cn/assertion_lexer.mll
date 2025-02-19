(* adapting from core_lexer *)
{
  exception Error

  module T = Assertion_parser_util
}

rule main = parse
  (* skip spaces *)
  | [' ' '\t']+ { main lexbuf }
  
  | "true"   { T.TRUE }
  | "false"  { T.FALSE }

  (* integer constants *)
  | ['0'-'9']+ as z  { T.Z (Z.of_string z) }

  | "let" { T.LET }
  | "="   { T.EQUAL }
  | "unchanged" { T.UNCHANGED }
  

  (* binary operators *)
  | '+'   { T.PLUS }
  | '-'   { T.MINUS }
  | '*'   { T.STAR }
  | '/'   { T.SLASH }

  | "=="  { T.EQ }
  | "!="  { T.NE }
  | '<'   { T.LT }
  | '>'   { T.GT }
  | "<="  { T.LE }
  | ">="  { T.GE }

  | "->"  { T.ARROW }

  | "flipBit" { T.FLIPBIT }

  | "(pointer)"   { T.POINTERCAST }
  | "(integer)"   { T.INTEGERCAST }

  | "pointer"     { T.POINTER }
  | "integer"     { T.INTEGER }

  | '('   { T.LPAREN }
  | ')'   { T.RPAREN }
  | '['   { T.LBRACKET }
  | ']'   { T.RBRACKET }
  | '{'   { T.LBRACE }
  | '}'   { T.RBRACE }
  | ','   { T.COMMA }
  | ';'   { T.SEMICOLON }

  | '?'   { T.QUESTION }
  | ':'   { T.COLON }
  | "||"  { T.OR }
  | "&&"  { T.AND }
  | '!'   { T.NOT }

  | "NULL" { T.NULL }
  | "offsetof" { T.OFFSETOF }
  | "cellPointer" { T.CELLPOINTER }
  | "disjoint"    { T.DISJOINT }

  | '&'   { T.AMPERSAND }
  | '@'   { T.AT }

  | "each" {T.EACH }
  | "for" {T.FOR }


  | "if" {T.IF }
  | "typeof" {T.TYPEOF }
  | "struct" {T.STRUCT }

  | "requires" {T.REQUIRES}
  | "ensures" {T.ENSURES}
  | "accesses" {T.ACCESSES}
  | "trusted" {T.TRUSTED}
  | "inv" {T.INV}
  | "cn_function" {T.CN_FUNCTION}
  
  | '\n' {Lexing.new_line lexbuf; main lexbuf}

  (* names *)
  | ['_' 'a'-'z']['0'-'9' 'A'-'Z' 'a'-'z' '_']* as name
      { T.LNAME name }
  | ['A'-'Z']['0'-'9' 'A'-'Z' 'a'-'z' '_']* as name
      { T.UNAME name }
  | '.' (['_' 'a'-'z' 'A'-'Z']['0'-'9' 'A'-'Z' 'a'-'z' '_']* as member)
      { T.MEMBER member }


  | eof  { T.EOF }
  | _
    { raise Error }
