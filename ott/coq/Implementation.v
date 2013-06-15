(* generated by Ott 0.21.2 from: Implementation_.ott *)

Require Import ZArith.

Require Export Range.
Require Import AilTypes.

Local Open Scope Z.

Inductive binaryMode :=
  | Two'sComplement   : binaryMode
  | One'sComplement   : binaryMode
  | SignPlusMagnitude : binaryMode.

(* From 6.3.1.1
— The rank of a signed integer type shall be greater than the rank of any signed integer
type with less precision.
— The rank of long long int shall be greater than the rank of long int, which
shall be greater than the rank of int, which shall be greater than the rank of short
int, which shall be greater than the rank of signed char.

Suppose precision P (long long int) < precision P (long int). Then ltRank P
(long long int) (long int). But the second bullet tells us that ltRank P (long
int) (long long int). So P (long int) ≤ precision P (long long int).
*)

Definition min_precision ibt : Z :=
  match ibt with
  | Ichar    => 8
  | Short    => 16
  | Int      => 16
  | Long     => 32
  | LongLong => 64
  end.

Record implementation := make_implementation {
  binary_mode : binaryMode;
  is_signed : integerType -> bool;
  precision : integerType -> Z;
  size_t : integerType;
  ptrdiff_t : integerType;

  is_signed_Signed   ibt : is_signed (Signed   ibt) = true;
  is_signed_Bool         : is_signed Bool           = false;
  is_signed_Unsigned ibt : is_signed (Unsigned ibt) = false;

  is_signed_size_t    : is_signed size_t    = false;
  is_signed_ptrdiff_t : is_signed ptrdiff_t = true;

  precision_ptrdiff_t : 16 <= precision ptrdiff_t;
  precision_size_t    : 16 <= precision size_t;

  precision_Char :  precision Char = if is_signed Char
                                       then precision (Signed   Ichar)
                                       else precision (Unsigned Ichar);

  precision_Bool            :  1 <= precision Bool;
  precision_Signed ibt      :  min_precision ibt <= precision (Signed ibt);

  (* Follows from 6.2.6.2 #2:
       if there are M value bits in the signed type and N in the unsigned
       type, then M ≤ N
   *)
  lePrecision_Signed_Unsigned ibt    : precision (Signed   ibt) <= precision (Unsigned    ibt);
  (* unsigned char has no padding. *)
  lePrecision_Signed_Unsigned_Ichar  : precision (Signed Ichar) <  precision (Unsigned  Ichar);

  lePrecision_Signed_Long_LongLong   : precision (Signed  Long) <= precision (Signed LongLong);
  lePrecision_Signed_Int_Long        : precision (Signed   Int) <= precision (Signed     Long);
  lePrecision_Signed_Short_Int       : precision (Signed Short) <= precision (Signed      Int);
  lePrecision_Signed_Ichar_Short     : precision (Signed Ichar) <= precision (Signed    Short);

  (* Note: this cannot be inferred from the standard text but it is vital for
           integer conversions.
   *)
  lePrecision_Unsigned_Long_LongLong : precision (Unsigned  Long) <= precision (Unsigned LongLong);
  lePrecision_Unsigned_Int_Long      : precision (Unsigned   Int) <= precision (Unsigned     Long);
  lePrecision_Unsigned_Short_Int     : precision (Unsigned Short) <= precision (Unsigned      Int);
  lePrecision_Unsigned_Ichar_Short   : precision (Unsigned Ichar) <= precision (Unsigned    Short);
  lePrecision_Unsigned_Bool_Ichar    : precision Bool             <= precision (Unsigned    Ichar)
}.
