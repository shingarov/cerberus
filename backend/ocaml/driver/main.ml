open Global_ocaml
open Pipeline

let (>>=) = Exception.except_bind
let (>>) m f = m >>= fun _ -> f
let return = Exception.except_return

let io, get_progress =
  let open Pipeline in
  let progress = ref 0 in
  { pass_message = begin
        let ref = ref 0 in
        fun str -> Debug_ocaml.print_success (string_of_int !ref ^ ". " ^ str);
                   incr ref;
                   return ()
      end;
    set_progress = begin
      fun _   -> incr progress;
                 return ()
      end;
    run_pp = begin
      fun opts doc -> run_pp opts doc;
                      return ()
      end;
    print_endline = begin
      fun str -> print_endline str;
                 return ();
      end;
    print_debug = begin
      fun n mk_str -> Debug_ocaml.print_debug n [] mk_str;
                      return ()
      end;
    warn = begin
      fun mk_str -> Debug_ocaml.warn [] mk_str;
                    return ()
      end;
  }, fun () -> !progress

let frontend (conf, io) filename core_std =
  if not (Sys.file_exists filename) then
    error ("The file `" ^ filename ^ "' doesn't exist.");
  if Filename.check_suffix filename ".co" || Filename.check_suffix filename ".o" then
    return @@ read_core_object core_std filename
  else if Filename.check_suffix filename ".c" then
    c_frontend (conf, io) core_std filename >>= fun (_, _, core_file) ->
    core_passes (conf, io) ~filename core_file
  else if Filename.check_suffix filename ".core" then
    core_frontend (conf, io) core_std ~filename
    >>= core_passes (conf, io) ~filename
  else
    Exception.fail (Location_ocaml.unknown, Errors.UNSUPPORTED
                      "The file extention is not supported")

let create_cpp_cmd cpp_cmd nostdinc macros_def macros_undef incl_dirs incl_files nolibc =
  let libc_dirs = [cerb_path ^ "/runtime/bmc"; cerb_path ^ "/runtime/libc/include"; cerb_path ^ "/runtime/libc/include/posix"] in
  let incl_dirs = if nostdinc then incl_dirs else libc_dirs @ incl_dirs in
  let macros_def = if nolibc then macros_def else ("CERB_WITH_LIB", None) :: macros_def in
  String.concat " " begin
    cpp_cmd ::
    List.map (function
        | (str1, None)      -> "-D" ^ str1
        | (str1, Some str2) -> "-D" ^ str1 ^ "=" ^ str2
      ) macros_def @
    List.map (fun str -> "-U" ^ str) macros_undef @
    List.map (fun str -> "-I" ^ str) incl_dirs @
    List.map (fun str -> "-include " ^ str) incl_files
  end

let core_libraries incl lib_paths libs =
  let lib_paths = if incl then (cerb_path ^ "/runtime/libc") :: lib_paths else lib_paths in
  let libs = if incl then "c" :: libs else libs in
  List.map (fun lib ->
      match List.fold_left (fun acc path ->
          match acc with
          | Some _ -> acc
          | None ->
            let file = path ^ "/lib" ^ lib ^ ".co" in
            if Sys.file_exists file then Some file else None
        ) None lib_paths with
      | Some f -> f
      | None -> failwith @@ "file lib" ^ lib ^ ".co not found"
    ) libs

let print_file f =
  let ic = open_in f in
  let rec loop () =
    try print_endline @@ input_line ic; loop ()
    with End_of_file -> ()
  in loop ()

let create_executable out =
  let out = if Filename.is_relative out then Filename.concat (Unix.getcwd ()) out else out in
  let oc = open_out out in
  output_string oc "#!/bin/sh\n";
  output_string oc @@ "cerberus --nolibc --exec " ^ out ^ ".co\n";
  close_out oc;
  Unix.chmod out 0o755

let dummy_core_file stdlib impl =
  let open Core in
  { main=    None;
    tagDefs= Pmap.empty compare;
    stdlib=  snd stdlib;
    impl=    impl;
    globs=   [];
    funs=    Pmap.empty compare;
    extern=  Pmap.empty compare;
    funinfo= Pmap.empty compare;
  }

let cerberus debug_level progress core_obj
             cpp_cmd nostdinc nolibc macros macros_undef
             incl_dirs incl_files cpp_only
             link_lib_path link_core_obj
             impl_name
             switches batch experimental_unseq
             astprints pprints ppflags
             rewrite_core
             fs_dump fs
             ocaml_corestd
             output_name
             files =
  Debug_ocaml.debug_level := debug_level;
  let cpp_cmd =
    create_cpp_cmd cpp_cmd nostdinc macros macros_undef incl_dirs incl_files nolibc
  in
  (* set global configuration *)
  set_cerb_conf "Ocaml" false Random false QuoteStd false false false;
  let conf = { astprints; pprints; ppflags; debug_level; typecheck_core = false;
               rewrite_core; sequentialise_core = true; cpp_cmd; cpp_stderr = true } in
  let prelude =
    (* Looking for and parsing the core standard library *)
    Switches.set switches;
    load_core_stdlib () >>= fun core_stdlib ->
    io.pass_message "Core standard library loaded." >>
    (* Looking for and parsing the implementation file *)
    load_core_impl core_stdlib impl_name >>= fun core_impl ->
    io.pass_message "Implementation file loaded." >>
    return (core_stdlib, core_impl)
  in
  let main core_std =
    Exception.foldlM (fun core_files file ->
        frontend (conf, io) file core_std >>= fun core_file ->
        return (core_file::core_files)) [] (core_libraries (not nolibc && not core_obj) link_lib_path link_core_obj @ files)
  in
  let epilogue n =
    if batch = `Batch then
      Printf.fprintf stderr "Time spent: %f seconds\n" (Sys.time ());
    if progress then get_progress ()
    else n
  in
  let success = Either.Right 0 in
  let runM = function
    | Exception.Exception err ->
        prerr_endline (Pp_errors.to_string err);
        epilogue 1
    | Exception.Result (Either.Left execs) ->
        List.iter print_string execs;
        epilogue 0
    | Exception.Result (Either.Right n) ->
        epilogue n
  in
  runM @@ match files with
    | [] ->
      if ocaml_corestd then
        prelude >>= fun (core_stdlib, core_impl) ->
        let dummy_core = dummy_core_file core_stdlib core_impl in
        Core_typing.typecheck_program dummy_core >>= fun core_typed ->
        let core_seq = Core_sequentialise.sequentialise_file core_typed in
        Codegen_corestd.gen_standalone core_seq;
        return success
      else
        Pp_errors.fatal "no input file"
    | [file] when core_obj ->
      prelude >>= frontend (conf, io) file >>= fun core_file ->
      begin match output_name with
        | Some output_file ->
          write_core_object core_file output_file
        | None ->
          let output_file = Filename.remove_extension file ^ ".co" in
          write_core_object core_file output_file
      end;
      return success
    | files ->
      (* Run only CPP *)
      if cpp_only then
        Exception.foldlM (fun () file ->
            cpp (conf, io) file >>= fun processed_file ->
            print_file processed_file;
            return ()
          ) () files >>= fun () ->
        return success
      (* Dump a core object (-c) *)
      else if core_obj then
        prelude >>= fun core_std ->
        Exception.foldlM (fun () file ->
          frontend (conf, io) file core_std >>= fun core_file ->
          let output_file = Filename.remove_extension file ^ ".co" in
          write_core_object core_file output_file;
          return ()
          ) () files >>= fun () ->
        return success
      else
        prelude >>= fun core_std ->
        main core_std >>= begin function
          | [] -> assert false
          | f::fs ->
            Core_linking.link (f::fs)
        end >>= Core_typing.typecheck_program >>= fun typed_core_file ->
        (* Ocaml backend mode *)
        let name =
          match output_name with
          | None -> "a.ml"
          | Some out -> out
        in
        let () = Tags.set_tagDefs typed_core_file.tagDefs in
        Codegen_ocaml.gen name ocaml_corestd typed_core_file >>= fun _ ->
        return success

(* CLI stuff *)
open Cmdliner

let macro_pair =
  let parser str =
    match String.index_opt str '=' with
      | None ->
          Result.Ok (str, None)
      | Some i ->
          let macro = String.sub str 0 i in
          let value = String.sub str (i+1) (String.length str - i - 1) in
          let is_digit n = 48 <= n && n <= 57 in
          if i = 0 || is_digit (Char.code (String.get macro 0)) then
            Result.Error (`Msg "macro name must be a C identifier")
          else
            Result.Ok (macro, Some value) in
  let printer ppf = function
    | (m, None)   -> Format.pp_print_string ppf m
    | (m, Some v) -> Format.fprintf ppf "%s=%s" m v in
  Arg.(conv (parser, printer))

let debug_level =
  let doc = "Set the debug message level to $(docv) (should range over [0-9])." in
  Arg.(value & opt int 0 & info ["d"; "debug"] ~docv:"N" ~doc)

let ocaml_corestd =
  let doc = "Generate coreStd.ml" in
  Arg.(value & flag & info ["ocaml-corestd"] ~doc)

let impl =
  let doc = "Set the C implementation file (to be found in CERB_COREPATH/impls\
             and excluding the .impl suffix)." in
  Arg.(value & opt string "gcc_4.9.0_x86_64-apple-darwin10.8.0" & info ["impl"]
         ~docv:"NAME" ~doc)

let core_obj =
  let doc = "Run frontend generating a target '.co' core object file." in
  Arg.(value & flag & info ["c"] ~doc)

let link_lib_path =
  let doc = "Adds a new library search path." in
  Arg.(value & opt_all string [] & info ["L"] ~docv:"X" ~doc)

let link_core_obj =
  let doc = "This option tells the core linker to search for lib$(docv).co \
             in the library search path." in
  Arg.(value & opt_all string [] & info ["l"] ~docv:"X" ~doc)

let output_file =
  let doc = "Write output to file." in
  Arg.(value & opt (some string) None & info ["o"] ~doc)

let cpp_cmd =
  let doc = "Command to call for the C preprocessing." in
  Arg.(value & opt string ("cc -std=c11 -E -C -Werror -nostdinc -undef -D__cerb__")
             & info ["cpp"] ~docv:"CMD" ~doc)

let cpp_only =
  let doc = "Run only the preprocessor stage." in
  Arg.(value & flag & info ["E"] ~doc)

let incl_dir =
  let doc = "Add the specified directory to the search path for the\
             C preprocessor." in
  Arg.(value & opt_all dir [] & info ["I"; "include-directory"]
         ~docv:"DIR" ~doc)

let macros =
  let doc = "Adds  an  implicit  #define  into the predefines buffer which is \
             read before the source file is preprocessed." in
  Arg.(value & opt_all macro_pair [] & info ["D"; "define-macro"]
         ~docv:"NAME[=VALUE]" ~doc)

let macros_undef =
  let doc = "Adds an implicit #undef into the predefines buffer which is read \
             before the source file is preprocessed." in
  Arg.(value & opt_all string [] & info ["U"] ~doc)

let incl_file =
  let doc = "Adds  an  implicit  #include into the predefines buffer which is \
             read before the source file is preprocessed." in
  Arg.(value & opt_all string [] & info ["include"] ~doc)

let nostdinc =
  let doc = "Do not search includes in the standard lib C directories." in
  Arg.(value & flag & info ["nostdinc"] ~doc)

let nolibc =
  let doc = "Do not search the standard system directories for include files." in
  Arg.(value & flag & info ["nolibc"] ~doc)

let pprints =
  let open Pipeline in
  let doc = "Pretty print the intermediate programs for the listed languages\
             (ranging over {ail, core})." in
  Arg.(value & opt (list (enum ["ail", Ail; "core", Core])) [] &
       info ["pp"] ~docv:"LANG1,..." ~doc)

let astprints =
  let open Pipeline in
  let doc = "Pretty print the intermediate syntax tree for the listed languages\
             (ranging over {cabs, ail, core})." in
  Arg.(value & opt (list (enum ["cabs", Cabs; "ail", Ail])) [] &
       info ["ast"] ~docv:"LANG1,..." ~doc)

let ppflags =
  let open Pipeline in
  let doc = "Pretty print flags [annot: include location and ISO annotations,\
             fout: output in a file]." in
  Arg.(value & opt (list (enum ["annot", Annot; "fout", FOut])) [] &
       info ["pp_flags"] ~doc)

let files =
  let doc = "source C or Core file" in
  Arg.(value & pos_all file [] & info [] ~docv:"FILE" ~doc)

let progress =
  let doc = "Progress mode: the return code indicate how far the source program\
             went through the pipeline \
             [1 = total failure, 10 = parsed, 11 = desugared, 12 = typed,\
             13 = elaborated, 14 = executed]" in
  Arg.(value & flag & info ["progress"] ~doc)

let rewrite =
  let doc = "Activate the Core to Core transformations" in
  Arg.(value & flag & info["rewrite"] ~doc)

let batch =
  let doc = "makes the execution driver produce batch friendly output" in
  Arg.(value & vflag `NotBatch & [(`Batch, info["batch"] ~doc);
                                  (`CharonBatch, info["charon-batch"]
                                     ~doc:(doc^" (for Charon)"))])

let experimental_unseq =
  let doc = "use a new (experimental) semantics for unseq() in Core_run" in
  Arg.(value & flag & info["experimental-unseq"] ~doc)

let fs =
  let doc = "Initialise the internal file system with the contents of the\
             directory DIR" in
  Arg.(value & opt (some string) None & info ["fs"] ~docv:"DIR" ~doc)

let fs_dump =
  let doc = "dump the file system at the end of the execution" in
  Arg.(value & flag & info["fs-dump"] ~doc)

let switches =
  let doc = "list of semantics switches to turn on (see documentation for the list)" in
  Arg.(value & opt (list string) [] & info ["switches"] ~docv:"SWITCH1,..." ~doc)

(* entry point *)
let () =
  let cerberus_t = Term.(pure cerberus $ debug_level $ progress $ core_obj $
                         cpp_cmd $ nostdinc $ nolibc $ macros $ macros_undef $
                         incl_dir $ incl_file $ cpp_only $
                         link_lib_path $ link_core_obj $
                         impl $
                         switches $ batch $
                         experimental_unseq $
                         astprints $ pprints $ ppflags $
                         rewrite $
                         fs_dump $ fs $
                         ocaml_corestd $
                         output_file $
                         files) in
  let version = Version.version in
  let info = Term.info "cerberus" ~version ~doc:"Cerberus C semantics"  in
  Term.exit @@ Term.eval (cerberus_t, info)
