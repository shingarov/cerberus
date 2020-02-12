(* Generated by Lem from ocaml_generated/builtins.lem. *)

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
Require Import ailSyntax.
Require Export ailSyntax.
Require Import ailTypesAux.
Require Export ailTypesAux.
Require Import ctype.
Require Export ctype.

Require Import memory_order.
Require Export memory_order.

(* [?]: removed value specification. *)

Definition translate_builtin_typenames   : string  -> option (ctype ) :=  
  fun (x : string ) =>
    match (x) with (* stdint.h *) | "__cerbty_int8_t" =>
      Some (mk_ctype_integer (Signed (IntN_t ( 8)))) | "__cerbty_int16_t" =>
      Some (mk_ctype_integer (Signed (IntN_t ( 16)))) | "__cerbty_int32_t" =>
      Some (mk_ctype_integer (Signed (IntN_t ( 32)))) | "__cerbty_int64_t" =>
      Some (mk_ctype_integer (Signed (IntN_t ( 64))))
      | "__cerbty_int128_t" =>
      Some (mk_ctype_integer (Signed (IntN_t ( 128))))
      | "__cerbty_int_fast8_t" =>
      Some (mk_ctype_integer (Signed (Int_fastN_t ( 8))))
      | "__cerbty_int_fast16_t" =>
      Some (mk_ctype_integer (Signed (Int_fastN_t ( 16))))
      | "__cerbty_int_fast32_t" =>
      Some (mk_ctype_integer (Signed (Int_fastN_t ( 32))))
      | "__cerbty_int_fast64_t" =>
      Some (mk_ctype_integer (Signed (Int_fastN_t ( 64))))
      | "__cerbty_int_least8_t" =>
      Some (mk_ctype_integer (Signed (Int_leastN_t ( 8))))
      | "__cerbty_int_least16_t" =>
      Some (mk_ctype_integer (Signed (Int_leastN_t ( 16))))
      | "__cerbty_int_least32_t" =>
      Some (mk_ctype_integer (Signed (Int_leastN_t ( 32))))
      | "__cerbty_int_least64_t" =>
      Some (mk_ctype_integer (Signed (Int_leastN_t ( 64))))
      | "__cerbty_intmax_t" => Some intmax_t | "__cerbty_intptr_t" =>
      Some intptr_t | "__cerbty_ptrdiff_t" => Some ptrdiff_t
      | "__cerbty_uint8_t" =>
      Some (mk_ctype_integer (Unsigned (IntN_t ( 8))))
      | "__cerbty_uint16_t" =>
      Some (mk_ctype_integer (Unsigned (IntN_t ( 16))))
      | "__cerbty_uint32_t" =>
      Some (mk_ctype_integer (Unsigned (IntN_t ( 32))))
      | "__cerbty_uint64_t" =>
      Some (mk_ctype_integer (Unsigned (IntN_t ( 64))))
      | "__cerbty_uint128_t" =>
      Some (mk_ctype_integer (Unsigned (IntN_t ( 128))))
      | "__cerbty_uint_fast8_t" =>
      Some (mk_ctype_integer (Unsigned (Int_fastN_t ( 8))))
      | "__cerbty_uint_fast16_t" =>
      Some (mk_ctype_integer (Unsigned (Int_fastN_t ( 16))))
      | "__cerbty_uint_fast32_t" =>
      Some (mk_ctype_integer (Unsigned (Int_fastN_t ( 32))))
      | "__cerbty_uint_fast64_t" =>
      Some (mk_ctype_integer (Unsigned (Int_fastN_t ( 64))))
      | "__cerbty_uint_least8_t" =>
      Some (mk_ctype_integer (Unsigned (Int_leastN_t ( 8))))
      | "__cerbty_uint_least16_t" =>
      Some (mk_ctype_integer (Unsigned (Int_leastN_t ( 16))))
      | "__cerbty_uint_least32_t" =>
      Some (mk_ctype_integer (Unsigned (Int_leastN_t ( 32))))
      | "__cerbty_uint_least64_t" =>
      Some (mk_ctype_integer (Unsigned (Int_leastN_t ( 64))))
      | "__cerbty_uintmax_t" => Some uintmax_t | "__cerbty_uintptr_t" =>
      Some uintptr_t (* setjmp.h *) | "__cerbty_jmp_buf" => None
    (* stddef.h *) | "__cerbty_max_align_t" => None | "__cerbty_size_t" =>
      Some size_t | "__cerbty_wchar_t" => Some wchar_t | _ => None end.
(* [?]: removed value specification. *)

Definition translate_errno   : string  -> Z :=  
  fun (x : string ) =>
    match (x) with | "__cerbvar_EDOM" => Coq.ZArith.BinIntDef.Z.of_nat 1
      | "__cerbvar_EILSEQ" => Coq.ZArith.BinIntDef.Z.of_nat 2
      | "__cerbvar_ERANGE" => Coq.ZArith.BinIntDef.Z.of_nat 3
      | "__cerbvar_E2BIG" => Coq.ZArith.BinIntDef.Z.of_nat 4
      | "__cerbvar_EACCES" => Coq.ZArith.BinIntDef.Z.of_nat 5
      | "__cerbvar_EADDRINUSE" => Coq.ZArith.BinIntDef.Z.of_nat 6
      | "__cerbvar_EADDRNOTAVAIL" => Coq.ZArith.BinIntDef.Z.of_nat 7
      | "__cerbvar_EAFNOSUPPORT" => Coq.ZArith.BinIntDef.Z.of_nat 8
      | "__cerbvar_EAGAIN" => Coq.ZArith.BinIntDef.Z.of_nat 9
      | "__cerbvar_EALREADY" => Coq.ZArith.BinIntDef.Z.of_nat 10
      | "__cerbvar_EBADF" => Coq.ZArith.BinIntDef.Z.of_nat 11
      | "__cerbvar_EBADMSG" => Coq.ZArith.BinIntDef.Z.of_nat 12
      | "__cerbvar_EBUSY" => Coq.ZArith.BinIntDef.Z.of_nat 13
      | "__cerbvar_ECANCELED" => Coq.ZArith.BinIntDef.Z.of_nat 14
      | "__cerbvar_ECHILD" => Coq.ZArith.BinIntDef.Z.of_nat 15
      | "__cerbvar_ECONNABORTED" => Coq.ZArith.BinIntDef.Z.of_nat 16
      | "__cerbvar_ECONNREFUSED" => Coq.ZArith.BinIntDef.Z.of_nat 17
      | "__cerbvar_ECONNRESET" => Coq.ZArith.BinIntDef.Z.of_nat 18
      | "__cerbvar_EDEADLK" => Coq.ZArith.BinIntDef.Z.of_nat 19
      | "__cerbvar_EDESTADDRREQ" => Coq.ZArith.BinIntDef.Z.of_nat 20
      | "__cerbvar_EDQUOT" => Coq.ZArith.BinIntDef.Z.of_nat 21
      | "__cerbvar_EEXIST" => Coq.ZArith.BinIntDef.Z.of_nat 22
      | "__cerbvar_EFAULT" => Coq.ZArith.BinIntDef.Z.of_nat 23
      | "__cerbvar_EFBIG" => Coq.ZArith.BinIntDef.Z.of_nat 24
      | "__cerbvar_EHOSTUNREACH" => Coq.ZArith.BinIntDef.Z.of_nat 25
      | "__cerbvar_EIDRM" => Coq.ZArith.BinIntDef.Z.of_nat 26
      | "__cerbvar_EINPROGRESS" => Coq.ZArith.BinIntDef.Z.of_nat 27
      | "__cerbvar_EINTR" => Coq.ZArith.BinIntDef.Z.of_nat 28
      | "__cerbvar_EINVAL" => Coq.ZArith.BinIntDef.Z.of_nat 29
      | "__cerbvar_EIO" => Coq.ZArith.BinIntDef.Z.of_nat 30
      | "__cerbvar_EISCONN" => Coq.ZArith.BinIntDef.Z.of_nat 31
      | "__cerbvar_EISDIR" => Coq.ZArith.BinIntDef.Z.of_nat 32
      | "__cerbvar_ELOOP" => Coq.ZArith.BinIntDef.Z.of_nat 33
      | "__cerbvar_EMFILE" => Coq.ZArith.BinIntDef.Z.of_nat 34
      | "__cerbvar_EMLINK" => Coq.ZArith.BinIntDef.Z.of_nat 35
      | "__cerbvar_EMSGSIZE" => Coq.ZArith.BinIntDef.Z.of_nat 36
      | "__cerbvar_EMULTIHOP" => Coq.ZArith.BinIntDef.Z.of_nat 37
      | "__cerbvar_ENAMETOOLONG" => Coq.ZArith.BinIntDef.Z.of_nat 38
      | "__cerbvar_ENETDOWN" => Coq.ZArith.BinIntDef.Z.of_nat 39
      | "__cerbvar_ENETRESET" => Coq.ZArith.BinIntDef.Z.of_nat 40
      | "__cerbvar_ENETUNREACH" => Coq.ZArith.BinIntDef.Z.of_nat 41
      | "__cerbvar_ENFILE" => Coq.ZArith.BinIntDef.Z.of_nat 42
      | "__cerbvar_ENOBUFS" => Coq.ZArith.BinIntDef.Z.of_nat 43
      | "__cerbvar_ENODATA" => Coq.ZArith.BinIntDef.Z.of_nat 44
      | "__cerbvar_ENODEV" => Coq.ZArith.BinIntDef.Z.of_nat 45
      | "__cerbvar_ENOENT" => Coq.ZArith.BinIntDef.Z.of_nat 46
      | "__cerbvar_ENOEXEC" => Coq.ZArith.BinIntDef.Z.of_nat 47
      | "__cerbvar_ENOLCK" => Coq.ZArith.BinIntDef.Z.of_nat 48
      | "__cerbvar_ENOLINK" => Coq.ZArith.BinIntDef.Z.of_nat 49
      | "__cerbvar_ENOMEM" => Coq.ZArith.BinIntDef.Z.of_nat 50
      | "__cerbvar_ENOMSG" => Coq.ZArith.BinIntDef.Z.of_nat 51
      | "__cerbvar_ENOPROTOOPT" => Coq.ZArith.BinIntDef.Z.of_nat 52
      | "__cerbvar_ENOSPC" => Coq.ZArith.BinIntDef.Z.of_nat 53
      | "__cerbvar_ENOSR" => Coq.ZArith.BinIntDef.Z.of_nat 54
      | "__cerbvar_ENOSTR" => Coq.ZArith.BinIntDef.Z.of_nat 55
      | "__cerbvar_ENOSYS" => Coq.ZArith.BinIntDef.Z.of_nat 56
      | "__cerbvar_ENOTCONN" => Coq.ZArith.BinIntDef.Z.of_nat 57
      | "__cerbvar_ENOTDIR" => Coq.ZArith.BinIntDef.Z.of_nat 58
      | "__cerbvar_ENOTEMPTY" => Coq.ZArith.BinIntDef.Z.of_nat 59
      | "__cerbvar_ENOTRECOVERABLE" => Coq.ZArith.BinIntDef.Z.of_nat 60
      | "__cerbvar_ENOTSOCK" => Coq.ZArith.BinIntDef.Z.of_nat 61
      | "__cerbvar_ENOTSUP" => Coq.ZArith.BinIntDef.Z.of_nat 62
      | "__cerbvar_ENOTTY" => Coq.ZArith.BinIntDef.Z.of_nat 63
      | "__cerbvar_ENXIO" => Coq.ZArith.BinIntDef.Z.of_nat 64
      | "__cerbvar_EOPNOTSUPP" => Coq.ZArith.BinIntDef.Z.of_nat 65
      | "__cerbvar_EOVERFLOW" => Coq.ZArith.BinIntDef.Z.of_nat 66
      | "__cerbvar_EOWNERDEAD" => Coq.ZArith.BinIntDef.Z.of_nat 67
      | "__cerbvar_EPERM" => Coq.ZArith.BinIntDef.Z.of_nat 68
      | "__cerbvar_EPIPE" => Coq.ZArith.BinIntDef.Z.of_nat 69
      | "__cerbvar_EPROTO" => Coq.ZArith.BinIntDef.Z.of_nat 70
      | "__cerbvar_EPROTONOSUPPORT" => Coq.ZArith.BinIntDef.Z.of_nat 71
      | "__cerbvar_EPROTOTYPE" => Coq.ZArith.BinIntDef.Z.of_nat 72
      | "__cerbvar_EROFS" => Coq.ZArith.BinIntDef.Z.of_nat 73
      | "__cerbvar_ESPIPE" => Coq.ZArith.BinIntDef.Z.of_nat 74
      | "__cerbvar_ESRCH" => Coq.ZArith.BinIntDef.Z.of_nat 75
      | "__cerbvar_ESTALE" => Coq.ZArith.BinIntDef.Z.of_nat 76
      | "__cerbvar_ETIME" => Coq.ZArith.BinIntDef.Z.of_nat 77
      | "__cerbvar_ETIMEDOUT" => Coq.ZArith.BinIntDef.Z.of_nat 78
      | "__cerbvar_ETXTBSY" => Coq.ZArith.BinIntDef.Z.of_nat 79
      | "__cerbvar_EWOULDBLOCK" => Coq.ZArith.BinIntDef.Z.of_nat 80
      | "__cerbvar_EXDEV" => Coq.ZArith.BinIntDef.Z.of_nat 81 | str =>
      apply (fun (_a : string )=> DAEMON)
        (String.append "Unknown errno code: " str) end.
(* [?]: removed value specification. *)

Definition encode_memory_order    : memory_order.memory_order  -> Z :=  
  fun (x : memory_order.memory_order ) =>
    match (x) with | memory_order.Relaxed => Coq.ZArith.BinIntDef.Z.of_nat 0
      | memory_order.Consume => Coq.ZArith.BinIntDef.Z.of_nat 1
      | memory_order.Acquire => Coq.ZArith.BinIntDef.Z.of_nat 2
      | memory_order.Release => Coq.ZArith.BinIntDef.Z.of_nat 3
      | memory_order.Acq_rel => Coq.ZArith.BinIntDef.Z.of_nat 4
      | memory_order.Seq_cst => Coq.ZArith.BinIntDef.Z.of_nat 5
      | memory_order.NA =>
      apply (fun (_a : string )=> DAEMON) "encode_memory_order NA" end.
(* [?]: removed value specification. *)

Definition decode_memory_order    : nat  -> option (memory_order.memory_order ) :=  
  fun (x : nat ) =>
    match (x) with | 0 => apply Some memory_order.Relaxed | 1 =>
      apply Some memory_order.Consume | 2 => apply Some memory_order.Acquire
      | 3 => apply Some memory_order.Release | 4 =>
      apply Some memory_order.Acq_rel | 5 => apply Some memory_order.Seq_cst
      | _ => None end.
(* [?]: removed value specification. *)

Definition translate_builtin_varnames  (i : symbol.identifier )  : option (expression_ (unit )) := 
  match ( (i)) with (( symbol.Identifier _ str)) =>
    let const_int := (fun (ic : integerConstant ) =>
                        Some (AilEconst (ConstantInteger ic))) in
  let const_ic := (fun (n : Z ) => apply const_int (IConstant n Decimal None)) in
  match ( str) with (* stddef.h *) | "__cerbvar_NULL" =>
    Some (AilEconst ConstantNull) (* errno.h *) | "__cerbvar_EDOM" =>
    apply const_ic (translate_errno str) | "__cerbvar_EILSEQ" =>
    apply const_ic (translate_errno str) | "__cerbvar_ERANGE" =>
    apply const_ic (translate_errno str) | "__cerbvar_E2BIG" =>
    apply const_ic (translate_errno str) | "__cerbvar_EACCES" =>
    apply const_ic (translate_errno str) | "__cerbvar_EADDRINUSE" =>
    apply const_ic (translate_errno str) | "__cerbvar_EADDRNOTAVAIL" =>
    apply const_ic (translate_errno str) | "__cerbvar_EAFNOSUPPORT" =>
    apply const_ic (translate_errno str) | "__cerbvar_EAGAIN" =>
    apply const_ic (translate_errno str) | "__cerbvar_EALREADY" =>
    apply const_ic (translate_errno str) | "__cerbvar_EBADF" =>
    apply const_ic (translate_errno str) | "__cerbvar_EBADMSG" =>
    apply const_ic (translate_errno str) | "__cerbvar_EBUSY" =>
    apply const_ic (translate_errno str) | "__cerbvar_ECANCELED" =>
    apply const_ic (translate_errno str) | "__cerbvar_ECHILD" =>
    apply const_ic (translate_errno str) | "__cerbvar_ECONNABORTED" =>
    apply const_ic (translate_errno str) | "__cerbvar_ECONNREFUSED" =>
    apply const_ic (translate_errno str) | "__cerbvar_ECONNRESET" =>
    apply const_ic (translate_errno str) | "__cerbvar_EDEADLK" =>
    apply const_ic (translate_errno str) | "__cerbvar_EDESTADDRREQ" =>
    apply const_ic (translate_errno str) | "__cerbvar_EDQUOT" =>
    apply const_ic (translate_errno str) | "__cerbvar_EEXIST" =>
    apply const_ic (translate_errno str) | "__cerbvar_EFAULT" =>
    apply const_ic (translate_errno str) | "__cerbvar_EFBIG" =>
    apply const_ic (translate_errno str) | "__cerbvar_EHOSTUNREACH" =>
    apply const_ic (translate_errno str) | "__cerbvar_EIDRM" =>
    apply const_ic (translate_errno str) | "__cerbvar_EINPROGRESS" =>
    apply const_ic (translate_errno str) | "__cerbvar_EINTR" =>
    apply const_ic (translate_errno str) | "__cerbvar_EINVAL" =>
    apply const_ic (translate_errno str) | "__cerbvar_EIO" =>
    apply const_ic (translate_errno str) | "__cerbvar_EISCONN" =>
    apply const_ic (translate_errno str) | "__cerbvar_EISDIR" =>
    apply const_ic (translate_errno str) | "__cerbvar_ELOOP" =>
    apply const_ic (translate_errno str) | "__cerbvar_EMFILE" =>
    apply const_ic (translate_errno str) | "__cerbvar_EMLINK" =>
    apply const_ic (translate_errno str) | "__cerbvar_EMSGSIZE" =>
    apply const_ic (translate_errno str) | "__cerbvar_EMULTIHOP" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENAMETOOLONG" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENETDOWN" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENETRESET" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENETUNREACH" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENFILE" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOBUFS" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENODATA" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENODEV" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOENT" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOEXEC" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOLCK" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOLINK" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOMEM" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOMSG" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOPROTOOPT" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOSPC" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOSR" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOSTR" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOSYS" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTCONN" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTDIR" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTEMPTY" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTRECOVERABLE" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTSOCK" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTSUP" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENOTTY" =>
    apply const_ic (translate_errno str) | "__cerbvar_ENXIO" =>
    apply const_ic (translate_errno str) | "__cerbvar_EOPNOTSUPP" =>
    apply const_ic (translate_errno str) | "__cerbvar_EOVERFLOW" =>
    apply const_ic (translate_errno str) | "__cerbvar_EOWNERDEAD" =>
    apply const_ic (translate_errno str) | "__cerbvar_EPERM" =>
    apply const_ic (translate_errno str) | "__cerbvar_EPIPE" =>
    apply const_ic (translate_errno str) | "__cerbvar_EPROTO" =>
    apply const_ic (translate_errno str) | "__cerbvar_EPROTONOSUPPORT" =>
    apply const_ic (translate_errno str) | "__cerbvar_EPROTOTYPE" =>
    apply const_ic (translate_errno str) | "__cerbvar_EROFS" =>
    apply const_ic (translate_errno str) | "__cerbvar_ESPIPE" =>
    apply const_ic (translate_errno str) | "__cerbvar_ESRCH" =>
    apply const_ic (translate_errno str) | "__cerbvar_ESTALE" =>
    apply const_ic (translate_errno str) | "__cerbvar_ETIME" =>
    apply const_ic (translate_errno str) | "__cerbvar_ETIMEDOUT" =>
    apply const_ic (translate_errno str) | "__cerbvar_ETXTBSY" =>
    apply const_ic (translate_errno str) | "__cerbvar_EWOULDBLOCK" =>
    apply const_ic (translate_errno str) | "__cerbvar_EXDEV" =>
    apply const_ic (translate_errno str) (* stdatomic.h *)
    | "__cerbvar_memory_order_relaxed" =>
    apply const_ic (encode_memory_order memory_order.Relaxed)
    | "__cerbvar_memory_order_consume" =>
    apply const_ic (encode_memory_order memory_order.Consume)
    | "__cerbvar_memory_order_acquire" =>
    apply const_ic (encode_memory_order memory_order.Acquire)
    | "__cerbvar_memory_order_release" =>
    apply const_ic (encode_memory_order memory_order.Release)
    | "__cerbvar_memory_order_acq_rel" =>
    apply const_ic (encode_memory_order memory_order.Acq_rel)
    | "__cerbvar_memory_order_seq_cst" =>
    apply const_ic (encode_memory_order memory_order.Seq_cst)
    | "__cerbvar_atomic_thread_fence" =>
    Some (AilEbuiltin (AilBatomic AilBAthread_fence))
    | "__cerbvar_atomic_store_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAstore))
    | "__cerbvar_atomic_load_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAload))
    | "__cerbvar_atomic_exchange_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAexchange))
    | "__cerbvar_atomic_compare_exchange_strong_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAcompare_exchange_strong))
    | "__cerbvar_atomic_compare_exchange_weak_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAcompare_exchange_weak))
    | "__cerbvar_atomic_fetch_key_explicit" =>
    Some (AilEbuiltin (AilBatomic AilBAfetch_key)) (* linux.h *)
    | "__cerbvar_linux_fence" => Some (AilEbuiltin (AilBlinux AilBLfence))
    | "__cerbvar_linux_read" => Some (AilEbuiltin (AilBlinux AilBLread))
    | "__cerbvar_linux_write" => Some (AilEbuiltin (AilBlinux AilBLwrite))
    | "__cerbvar_linux_rmw" => Some (AilEbuiltin (AilBlinux AilBLrmw))
  (* stdint.h *) | "__cerbvar_CHAR_BIT" =>
    (* TODO/FIXME: this depends on the implementation *) const_ic
      (Coq.ZArith.BinIntDef.Z.of_nat 8) | "__cerbvar_SCHAR_MIN" =>
    apply const_int (IConstantMin (Signed Ichar)) | "__cerbvar_SCHAR_MAX" =>
    apply const_int (IConstantMax (Signed Ichar)) | "__cerbvar_UCHAR_MAX" =>
    apply const_int (IConstantMax (Unsigned Ichar)) | "__cerbvar_CHAR_MIN" =>
    apply const_int (IConstantMin Char) | "__cerbvar_CHAR_MAX" =>
    apply const_int (IConstantMax Char) | "__cerbvar_SHRT_MIN" =>
    apply const_int (IConstantMin (Signed Short)) | "__cerbvar_SHRT_MAX" =>
    apply const_int (IConstantMax (Signed Short)) | "__cerbvar_USHRT_MAX" =>
    apply const_int (IConstantMax (Unsigned Short)) | "__cerbvar_INT_MIN" =>
    apply const_int (IConstantMin (Signed Int_)) | "__cerbvar_INT_MAX" =>
    apply const_int (IConstantMax (Signed Int_)) | "__cerbvar_UINT_MAX" =>
    apply const_int (IConstantMax (Unsigned Int_)) | "__cerbvar_LONG_MIN" =>
    apply const_int (IConstantMin (Signed Long)) | "__cerbvar_LONG_MAX" =>
    apply const_int (IConstantMax (Signed Long)) | "__cerbvar_ULONG_MAX" =>
    apply const_int (IConstantMax (Unsigned Long)) | "__cerbvar_LLONG_MIN" =>
    apply const_int (IConstantMin (Signed LongLong))
    | "__cerbvar_LLONG_MAX" =>
    apply const_int (IConstantMax (Signed LongLong))
    | "__cerbvar_ULLONG_MAX" =>
    apply const_int (IConstantMax (Unsigned LongLong))
    | "__cerbvar_INT8_MIN" =>
    apply const_int (IConstantMin (Signed (IntN_t ( 8))))
    | "__cerbvar_INT16_MIN" =>
    apply const_int (IConstantMin (Signed (IntN_t ( 16))))
    | "__cerbvar_INT32_MIN" =>
    apply const_int (IConstantMin (Signed (IntN_t ( 32))))
    | "__cerbvar_INT64_MIN" =>
    apply const_int (IConstantMin (Signed (IntN_t ( 64))))
    | "__cerbvar_INT8_MAX" =>
    apply const_int (IConstantMax (Signed (IntN_t ( 8))))
    | "__cerbvar_INT16_MAX" =>
    apply const_int (IConstantMax (Signed (IntN_t ( 16))))
    | "__cerbvar_INT32_MAX" =>
    apply const_int (IConstantMax (Signed (IntN_t ( 32))))
    | "__cerbvar_INT64_MAX" =>
    apply const_int (IConstantMax (Signed (IntN_t ( 64))))
    | "__cerbvar_UINT8_MAX" =>
    apply const_int (IConstantMax (Unsigned (IntN_t ( 8))))
    | "__cerbvar_UINT16_MAX" =>
    apply const_int (IConstantMax (Unsigned (IntN_t ( 16))))
    | "__cerbvar_UINT32_MAX" =>
    apply const_int (IConstantMax (Unsigned (IntN_t ( 32))))
    | "__cerbvar_UINT64_MAX" =>
    apply const_int (IConstantMax (Unsigned (IntN_t ( 64))))
    | "__cerbvar_INTPTR_MIN" =>
    apply const_int (IConstantMin (Signed Intptr_t))
    | "__cerbvar_INTPTR_MAX" =>
    apply const_int (IConstantMax (Signed Intptr_t))
    | "__cerbvar_UINTPTR_MAX" =>
    apply const_int (IConstantMax (Unsigned Intptr_t))
    | "__cerbvar_INTMAX_MIN" =>
    apply const_int (IConstantMin (Signed Intmax_t))
    | "__cerbvar_INTMAX_MAX" =>
    apply const_int (IConstantMax (Signed Intmax_t))
    | "__cerbvar_UINTMAX_MAX" =>
    apply const_int (IConstantMax (Unsigned Intmax_t))
    | "__cerbvar_PTRDIFF_MIN" => apply const_int (IConstantMin Ptrdiff_t)
    | "__cerbvar_PTRDIFF_MAX" => apply const_int (IConstantMax Ptrdiff_t)
    | "__cerbvar_INT_LEAST8_MIN" =>
    apply const_int (IConstantMin (Signed (Int_leastN_t ( 8))))
    | "__cerbvar_INT_LEAST16_MIN" =>
    apply const_int (IConstantMin (Signed (Int_leastN_t ( 16))))
    | "__cerbvar_INT_LEAST32_MIN" =>
    apply const_int (IConstantMin (Signed (Int_leastN_t ( 32))))
    | "__cerbvar_INT_LEAST64_MIN" =>
    apply const_int (IConstantMin (Signed (Int_leastN_t ( 64))))
    | "__cerbvar_INT_LEAST8_MAX" =>
    apply const_int (IConstantMax (Signed (Int_leastN_t ( 8))))
    | "__cerbvar_INT_LEAST16_MAX" =>
    apply const_int (IConstantMax (Signed (Int_leastN_t ( 16))))
    | "__cerbvar_INT_LEAST32_MAX" =>
    apply const_int (IConstantMax (Signed (Int_leastN_t ( 32))))
    | "__cerbvar_INT_LEAST64_MAX" =>
    apply const_int (IConstantMax (Signed (Int_leastN_t ( 64))))
    | "__cerbvar_UINT_LEAST8_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_leastN_t ( 8))))
    | "__cerbvar_UINT_LEAST16_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_leastN_t ( 16))))
    | "__cerbvar_UINT_LEAST32_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_leastN_t ( 32))))
    | "__cerbvar_UINT_LEAST64_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_leastN_t ( 64))))
    | "__cerbvar_INT_FAST8_MIN" =>
    apply const_int (IConstantMin (Signed (Int_fastN_t ( 8))))
    | "__cerbvar_INT_FAST16_MIN" =>
    apply const_int (IConstantMin (Signed (Int_fastN_t ( 16))))
    | "__cerbvar_INT_FAST32_MIN" =>
    apply const_int (IConstantMin (Signed (Int_fastN_t ( 32))))
    | "__cerbvar_INT_FAST64_MIN" =>
    apply const_int (IConstantMin (Signed (Int_fastN_t ( 64))))
    | "__cerbvar_INT_FAST8_MAX" =>
    apply const_int (IConstantMax (Signed (Int_fastN_t ( 8))))
    | "__cerbvar_INT_FAST16_MAX" =>
    apply const_int (IConstantMax (Signed (Int_fastN_t ( 16))))
    | "__cerbvar_INT_FAST32_MAX" =>
    apply const_int (IConstantMax (Signed (Int_fastN_t ( 32))))
    | "__cerbvar_INT_FAST64_MAX" =>
    apply const_int (IConstantMax (Signed (Int_fastN_t ( 64))))
    | "__cerbvar_UINT_FAST8_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_fastN_t ( 8))))
    | "__cerbvar_UINT_FAST16_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_fastN_t ( 16))))
    | "__cerbvar_UINT_FAST32_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_fastN_t ( 32))))
    | "__cerbvar_UINT_FAST64_MAX" =>
    apply const_int (IConstantMax (Unsigned (Int_fastN_t ( 64))))
    | "__cerbvar_SIZE_MAX" => apply const_int (IConstantMax Size_t)
    | "__cerbvar_WCHAR_MIN" => apply const_int (IConstantMin Wchar_t)
    | "__cerbvar_WCHAR_MAX" => apply const_int (IConstantMax Wchar_t)
    | "__cerbvar_WINT_MIN" => apply const_int (IConstantMin Wint_t)
    | "__cerbvar_WINT_MAX" => apply const_int (IConstantMax Wint_t) | _ =>
    None end end.
(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

(* [?]: removed value specification. *)

