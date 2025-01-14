open Cn

open Pp_prelude
open Pp_ast
open Pp_symbol

open Location_ocaml


module P = PPrint


let string_of_ns = function
  | CN_oarg -> "output argument"
  | CN_logical -> "logical variable"
  | CN_predicate -> "predicate"
  | CN_function -> "specification function"
  | CN_datatype_nm -> "datatype"
  | CN_constructor -> "constructor"

let string_of_error = function
  | CNErr_uppercase_function (Symbol.Identifier (_, str)) ->
      "function name `" ^ str ^ "' does not start with a lowercase letter"
  | CNErr_lowercase_predicate (Symbol.Identifier (_, str)) ->
      "predicate name `" ^ str ^ "' does not start with an uppercase letter"
  | CNErr_redeclaration ns ->
      "redeclaration of " ^ string_of_ns ns
  | CNErr_unknown_predicate ->
      "undeclared predicate name"
  | CNErr_invalid_tag ->
      "tag name is no declared or a union tag"
  | CNErr_unknown_identifier (ns, Symbol.Identifier (_, str)) ->
      "the " ^ string_of_ns ns ^ " `" ^ str ^ "' is not declared"
  | CNErr_missing_oarg sym ->
      "missing an assignment for the oarg `" ^ Pp_symbol.to_string_pretty sym ^ "'" 
    


module type PP_CN = sig
  type ident
  type ty
  val pp_ident: ?clever:bool -> ident -> P.document
  val pp_ty: ty -> P.document
end

module MakePp (Conf: PP_CN) = struct
  let rec pp_base_type = function
    | CN_unit ->
        pp_type_keyword "unit"
    | CN_bool ->
        pp_type_keyword "bool"
    | CN_integer ->
        pp_type_keyword "integer"
    | CN_real ->
        pp_type_keyword "real"
    | CN_loc ->
        pp_type_keyword "loc"
    | CN_struct ident ->
        pp_type_keyword "struct" ^^^ P.squotes (Conf.pp_ident ident)
    | CN_datatype ident ->
        pp_type_keyword "datatype" ^^^ P.squotes (Conf.pp_ident ident)
    | CN_map (bTy1, bTy2) ->
        pp_type_keyword "map" ^^ P.angles (pp_base_type bTy1 ^^ P.comma ^^^ pp_base_type bTy2)
    | CN_list bTy ->
        pp_type_keyword "list" ^^ P.angles (pp_base_type bTy)
    | CN_tuple bTys ->
        pp_type_keyword "tuple" ^^ P.angles (comma_list pp_base_type bTys)
    | CN_set bTy ->
        pp_type_keyword "set" ^^ P.angles (pp_base_type bTy)

  let pp_cn_binop = function
    | CN_add -> P.plus
    | CN_sub -> P.minus
    | CN_mul -> P.star
    | CN_div -> P.slash
    | CN_equal -> P.equals ^^ P.equals
    | CN_inequal -> P.backslash ^^ P.equals
    | CN_lt -> P.langle
    | CN_gt -> P.rangle
    | CN_le -> P.langle ^^ P.equals
    | CN_ge -> P.rangle ^^ P.equals
    | CN_or -> P.bar ^^ P.bar
    | CN_and -> P.ampersand ^^ P.ampersand
    | CN_map_get -> P.string "CN_map_get"
  
  let rec dtree_of_cn_expr (CNExpr (_, expr_)) =
    match expr_ with
      | CNExpr_const CNConst_NULL ->
          Dleaf (pp_ctor "CNExpr_const" ^^^ !^ "NULL")
      | CNExpr_const CNConst_integer n ->
          Dleaf (pp_ctor "CNExpr_const" ^^^ !^ (Z.to_string n))
      | CNExpr_const (CNConst_bool b) ->
          Dleaf (pp_ctor "CNExpr_const" ^^^ !^ (if b then "true" else "false"))
      | CNExpr_var ident ->
          Dleaf (pp_ctor "CNExpr_var" ^^^ P.squotes (Conf.pp_ident ident))
      | CNExpr_rvar ident ->
          Dleaf (pp_ctor "CNExpr_rvar" ^^^ P.squotes (Conf.pp_ident ident))
      | CNExpr_list es ->
          Dnode (pp_ctor "CNExpr_list", List.map dtree_of_cn_expr es)
      | CNExpr_memberof (e, z) ->
          Dnode (pp_ctor "CNExpr_member",
                [dtree_of_cn_expr e;
                 Dleaf (pp_identifier z)])
      | CNExpr_binop (bop, e1, e2) ->
          Dnode (pp_ctor "CNExpr_binop" ^^^ pp_cn_binop bop, [dtree_of_cn_expr e1; dtree_of_cn_expr e2])
      | CNExpr_sizeof ty ->
          Dleaf (pp_ctor "CNExpr_sizeof" ^^^ Conf.pp_ty ty)
      | CNExpr_offsetof (ty_tag, member) ->
          Dleaf (pp_ctor "CNExpr_offsetof" ^^^ P.squotes (Conf.pp_ident ty_tag) ^^^
                P.squotes (pp_identifier member))
      | CNExpr_cast (ty, expr) ->
          Dnode (pp_ctor "CNExpr_cast" ^^^ pp_base_type ty, [dtree_of_cn_expr expr])
      | CNExpr_call (nm, exprs) ->
          Dnode (pp_ctor "CNExpr_call" ^^^ P.squotes (pp_identifier nm)
                 , List.map dtree_of_cn_expr exprs)
      | CNExpr_cons (nm, xs) ->
          let docs =
            List.map (fun (ident, e) ->
              Dnode (pp_identifier ident, [dtree_of_cn_expr e])
            ) xs in
          Dnode (pp_ctor "CNExpr_cons" ^^^ P.squotes (Conf.pp_ident nm), docs)
      | CNExpr_each (ident, r, expr) ->
          Dnode (pp_ctor "CNExpr_each" ^^^ P.squotes (Conf.pp_ident ident) ^^^
                     !^ (Z.to_string (fst r)) ^^^ P.string "-" ^^^ !^ (Z.to_string (snd r))
                 , [dtree_of_cn_expr expr])
      | CNExpr_ite (e1, e2, e3) ->
          Dnode (pp_ctor "CNExpr_ite"
               , List.map dtree_of_cn_expr [e1;e2;e3])

  let dtree_of_cn_pred = function
    | CN_owned ty ->
      Dleaf (pp_stmt_ctor "CN_owned" ^^^ Conf.pp_ty ty)
    | CN_block ty ->
      Dleaf (pp_stmt_ctor "CN_block" ^^^ Conf.pp_ty ty)
    | CN_named ident ->
        Dleaf (pp_stmt_ctor "CN_named" ^^^ P.squotes (Conf.pp_ident ident))

  let dtree_of_cn_resource = function
    | CN_pred (_, pred, es) ->
        Dnode (pp_stmt_ctor "CN_pred", dtree_of_cn_pred pred :: List.map dtree_of_cn_expr es)
    | CN_each (ident, bTy, e, _, pred, es) ->
        Dnode ( pp_stmt_ctor "CN_each" ^^^ P.squotes (Conf.pp_ident ident) ^^^ P.colon ^^^ pp_base_type bTy
              , List.map dtree_of_cn_expr es )

  let rec dtree_of_cn_func_body = function
    | CN_fb_letExpr (_, ident, e, c) ->
        Dnode ( pp_stmt_ctor "CN_fb_letExpr" ^^^ P.squotes (Conf.pp_ident ident)
              , [dtree_of_cn_expr e; dtree_of_cn_func_body c])
    | CN_fb_return (_, x) ->
       dtree_of_cn_expr x
    | CN_fb_cases (_, x, xs) ->
       Dnode (pp_stmt_ctor "CN_fb_cases"
             , dtree_of_cn_expr x :: List.map dtree_of_cn_fb_case xs)
  and dtree_of_cn_fb_case (nm, x) = 
       Dnode (pp_stmt_ctor "case" ^^^ P.squotes (Conf.pp_ident nm)
             , [dtree_of_cn_func_body x])

  let dtree_of_o_cn_func_body = function
    | None -> Dleaf !^"uninterpreted"
    | Some body -> Dnode (!^"interpreted", [dtree_of_cn_func_body body])

  let dtree_of_cn_assertion = function
    | CN_assert_exp e -> Dnode (pp_stmt_ctor "CN_assert_exp", [dtree_of_cn_expr e])
    | CN_assert_qexp (ident, bTy, e1, e2) ->
        Dnode (pp_stmt_ctor "CN_assert_qexp" ^^^
                  P.squotes (Conf.pp_ident ident)^^ P.colon ^^^ pp_base_type bTy
              , [dtree_of_cn_expr e1; dtree_of_cn_expr e2])

  let rec dtree_of_cn_clause = function
    | CN_letResource (_, ident, res, c) ->
        Dnode ( pp_stmt_ctor "CN_letResource" ^^^ P.squotes (Conf.pp_ident ident)
              , [dtree_of_cn_resource res; dtree_of_cn_clause c])
    | CN_letExpr (_, ident, e, c) ->
        Dnode ( pp_stmt_ctor "CN_letExpr" ^^^ P.squotes (Conf.pp_ident ident)
              , [dtree_of_cn_expr e; dtree_of_cn_clause c])
    | CN_assert (_, a, c) ->
        Dnode (pp_stmt_ctor "CN_assert", [dtree_of_cn_assertion a; dtree_of_cn_clause c])
    | CN_return (_, xs) ->
        let docs =
            List.map (fun (ident, e) ->
              Dnode (Conf.pp_ident ident, [dtree_of_cn_expr e])
            ) xs in
        Dnode (pp_stmt_ctor "CN_return", docs)

  let rec dtree_of_cn_clauses = function
    | CN_clause (_, c) ->
        dtree_of_cn_clause c
    | CN_if (_, e, c1, c2) ->
        Dnode (pp_stmt_ctor "CN_if", [dtree_of_cn_expr e; dtree_of_cn_clause c1; dtree_of_cn_clauses c2])

  let dtree_of_option_cn_clauses = function
    | Some clauses -> 
       Dnode (pp_stmt_ctor "Some", [dtree_of_cn_clauses clauses])
    | None -> 
       Dnode (pp_stmt_ctor "None", [])


  let dtrees_of_attrs xs = List.map (fun ident -> Dleaf (pp_identifier ident)) xs

  let dtrees_of_args xs =
    List.map (fun (bTy, ident) ->
        Dleaf (Conf.pp_ident ident ^^ P.colon ^^^ pp_base_type bTy)
      ) xs

  let dtree_of_cn_function func =
    Dnode ( pp_ctor "[CN]function" ^^^ P.squotes (Conf.pp_ident func.cn_func_name)
          , [ Dnode (pp_ctor "[CN]attrs", dtrees_of_attrs func.cn_func_attrs)
            ; Dnode (pp_ctor "[CN]args", dtrees_of_args func.cn_func_args)
            ; Dnode (pp_ctor "[CN]body", [dtree_of_o_cn_func_body func.cn_func_body])
            ; Dnode (pp_ctor "[CN]return_bty", [Dleaf (pp_base_type func.cn_func_return_bty)]) ] ) 

  let dtree_of_cn_predicate pred =
    Dnode ( pp_ctor "[CN]predicate" ^^^ P.squotes (Conf.pp_ident pred.cn_pred_name)
          , [ Dnode (pp_ctor "[CN]attrs", dtrees_of_attrs pred.cn_pred_attrs)
            ; Dnode (pp_ctor "[CN]iargs", dtrees_of_args pred.cn_pred_iargs)
            ; Dnode (pp_ctor "[CN]oargs", dtrees_of_args pred.cn_pred_oargs)
            ; Dnode (pp_ctor "[CN]clauses", [dtree_of_option_cn_clauses pred.cn_pred_clauses]) ] ) 

  let dtrees_of_dt_args xs =
    List.map (fun (bTy, ident) ->
        Dleaf (pp_identifier ident ^^ P.colon ^^^ pp_base_type bTy)
      ) xs

  let dtree_of_cn_case (nm, args) =
    Dnode ( pp_ctor "[CN]constructor" ^^^ P.squotes (Conf.pp_ident nm)
          , [ Dnode (pp_ctor "[CN]args", dtrees_of_dt_args args) ] )

  let dtree_of_cn_datatype dt =
    Dnode ( pp_ctor "[CN]datatype" ^^^ P.squotes (Conf.pp_ident dt.cn_dt_name)
          , [ Dnode (pp_ctor "[CN]cases", List.map dtree_of_cn_case dt.cn_dt_cases) ])

end

module PpCabs = MakePp (struct
  type ident = Symbol.identifier
  type ty = Cabs.type_name
  let pp_ident = pp_identifier
  let pp_ty _ = failwith "PpCabs.pp_type_name"
end)

module PpAil = MakePp (struct
  type ident = Symbol.sym
  type ty = Ctype.ctype
  let pp_ident ?(clever=false) sym = !^ (Colour.ansi_format [Yellow] (Pp_symbol.to_string_pretty sym))
  let pp_ty ty = Pp_ail.pp_ctype Ctype.no_qualifiers ty
end)
