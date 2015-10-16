header{*Generated by Lem from num.lem.*}

theory "Lem_num" 

imports 
 	 Main
	 "Lem_bool" 
	 "Lem_basic_classes" 
	 "~~/src/HOL/Word/Word" 

begin 



(*open import Bool Basic_classes*)
(*open import {isabelle} `~~/src/HOL/Word/Word`*)
(*open import {hol} `integerTheory` `intReduce` `wordsTheory` `wordsLib`*)
(*open import {coq} `Coq.Numbers.BinNums` `Coq.ZArith.BinInt` `Coq.ZArith.Zpower` `Coq.ZArith.Zdiv` `Coq.ZArith.Zmax` `Coq.Numbers.Natural.Peano.NPeano`*) 

(*class inline ( Numeral 'a ) 
  val fromNumeral : numeral -> 'a 
end*)

(* ========================================================================== *)
(* Syntactic type-classes for common operations                               *)
(* ========================================================================== *)

(* Typeclasses can be used as a mean to overload constants like +, -, etc *)

record 'a NumNegate_class= 
 
  numNegate_method ::" 'a \<Rightarrow> 'a " 



record 'a NumAbs_class= 
 
  abs_method ::" 'a \<Rightarrow> 'a " 



record 'a NumAdd_class= 
 
  numAdd_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "



record 'a NumMinus_class= 
 
  numMinus_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "



record 'a NumMult_class= 
 
  numMult_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "



record 'a NumPow_class= 
 
  numPow_method ::" 'a \<Rightarrow> nat \<Rightarrow> 'a "



record 'a NumDivision_class= 
 
  numDivision_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "



record 'a NumIntegerDivision_class= 
 
  div_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "




record 'a NumRemainder_class= 
 
  mod_method ::" 'a \<Rightarrow> 'a \<Rightarrow> 'a "



record 'a NumSucc_class= 
 
  succ_method ::" 'a \<Rightarrow> 'a "



record 'a NumPred_class= 
 
  pred_method ::" 'a \<Rightarrow> 'a "

 


(* ----------------------- *)
(* natural                 *)
(* ----------------------- *)

(* unbounded size natural numbers *)
(*type natural*)


(* ----------------------- *)
(* int                     *)
(* ----------------------- *)

(* bounded size integers with uncertain length *)

(*type int*)


(* ----------------------- *)
(* integer                 *)
(* ----------------------- *)

(* unbounded size integers *)

(*type integer*)

(* ----------------------- *)
(* bint                    *)
(* ----------------------- *)

(* TODO the bounded ints are only partially implemented, use with care. *)

(* 32 bit integers *)
(*type int32*) 

(* 64 bit integers *)
(*type int64*) 


(* ----------------------- *)
(* rational                *)
(* ----------------------- *)

(* unbounded size and precision rational numbers *)

(*type rational*) (* ???: better type for this in HOL? *)


(* ----------------------- *)
(* double                  *)
(* ----------------------- *)

(* double precision floating point (64 bits) *)

(*type float64*) (* ???: better type for this in HOL? *)

(*type float32*) (* ???: better type for this in HOL? *)


(* ========================================================================== *)
(* Binding the standard operations for the number types                       *)
(* ========================================================================== *)


(* ----------------------- *)
(* nat                     *)
(* ----------------------- *)

(*val natFromNumeral : numeral -> nat*)

(*val natEq : nat -> nat -> bool*)

(*val natLess : nat -> nat -> bool*)
(*val natLessEqual : nat -> nat -> bool*)
(*val natGreater : nat -> nat -> bool*)
(*val natGreaterEqual : nat -> nat -> bool*)

(*val natCompare : nat -> nat -> ordering*)

definition instance_Basic_classes_Ord_nat_dict  :: "(nat)Ord_class "  where 
     " instance_Basic_classes_Ord_nat_dict = ((|

  compare_method = (genericCompare (op<) (op=)),

  isLess_method = (op<),

  isLessEqual_method = (op \<le>),

  isGreater_method = (op>),

  isGreaterEqual_method = (op \<ge>)|) )"


(*val natAdd : nat -> nat -> nat*)

definition instance_Num_NumAdd_nat_dict  :: "(nat)NumAdd_class "  where 
     " instance_Num_NumAdd_nat_dict = ((|

  numAdd_method = (op+)|) )"


(*val natMinus : nat -> nat -> nat*)

definition instance_Num_NumMinus_nat_dict  :: "(nat)NumMinus_class "  where 
     " instance_Num_NumMinus_nat_dict = ((|

  numMinus_method = (op-)|) )"


(*val natSucc : nat -> nat*)
(*let natSucc n = (Instance_Num_NumAdd_nat.+) n 1*)
definition instance_Num_NumSucc_nat_dict  :: "(nat)NumSucc_class "  where 
     " instance_Num_NumSucc_nat_dict = ((|

  succ_method = Suc |) )"


(*val natPred : nat -> nat*)
definition instance_Num_NumPred_nat_dict  :: "(nat)NumPred_class "  where 
     " instance_Num_NumPred_nat_dict = ((|

  pred_method = (\<lambda> n. n -( 1 :: nat))|) )"


(*val natMult : nat -> nat -> nat*)

definition instance_Num_NumMult_nat_dict  :: "(nat)NumMult_class "  where 
     " instance_Num_NumMult_nat_dict = ((|

  numMult_method = (op*)|) )"


(*val natDiv : nat -> nat -> nat*)

definition instance_Num_NumIntegerDivision_nat_dict  :: "(nat)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_nat_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_nat_dict  :: "(nat)NumDivision_class "  where 
     " instance_Num_NumDivision_nat_dict = ((|

  numDivision_method = (op div)|) )"


(*val natMod : nat -> nat -> nat*)

definition instance_Num_NumRemainder_nat_dict  :: "(nat)NumRemainder_class "  where 
     " instance_Num_NumRemainder_nat_dict = ((|

  mod_method = (op mod)|) )"



(*val gen_pow_aux : forall 'a. ('a -> 'a -> 'a) -> 'a -> 'a -> nat -> 'a*)
fun  gen_pow_aux  :: "('a \<Rightarrow> 'a \<Rightarrow> 'a)\<Rightarrow> 'a \<Rightarrow> 'a \<Rightarrow> nat \<Rightarrow> 'a "  where 
     " gen_pow_aux (mul :: 'a \<Rightarrow> 'a \<Rightarrow> 'a) (a :: 'a) (b :: 'a) (e :: nat) = (
   (case  e of
       0 => a (* cannot happen, call discipline guarentees e >= 1 *)
     | (Suc 0) => mul a b
     | (  (Suc(Suc e'))) => (let e'' = (e div( 2 :: nat)) in
                   (let a' = (if (e mod( 2 :: nat)) =( 0 :: nat) then a else mul a b) in
                   gen_pow_aux mul a' (mul b b) e''))
   ))" 
declare gen_pow_aux.simps [simp del]

       
definition gen_pow  :: " 'a \<Rightarrow>('a \<Rightarrow> 'a \<Rightarrow> 'a)\<Rightarrow> 'a \<Rightarrow> nat \<Rightarrow> 'a "  where 
     " gen_pow (one :: 'a) (mul :: 'a \<Rightarrow> 'a \<Rightarrow> 'a) (b :: 'a) (e :: nat) = ( 
  if e <( 0 :: nat) then one else 
  if (e =( 0 :: nat)) then one else gen_pow_aux mul one b e )"


(*val natPow : nat -> nat -> nat*)

definition instance_Num_NumPow_nat_dict  :: "(nat)NumPow_class "  where 
     " instance_Num_NumPow_nat_dict = ((|

  numPow_method = (op^)|) )"


(*val natMin : nat -> nat -> nat*)

(*val natMax : nat -> nat -> nat*)

definition instance_Basic_classes_OrdMaxMin_nat_dict  :: "(nat)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_nat_dict = ((|

  max_method = max,

  min_method = min |) )"



(* ----------------------- *)
(* natural                 *)
(* ----------------------- *)

(*val naturalFromNumeral : numeral -> natural*)

(*val naturalEq : natural -> natural -> bool*)

(*val naturalLess : natural -> natural -> bool*)
(*val naturalLessEqual : natural -> natural -> bool*)
(*val naturalGreater : natural -> natural -> bool*)
(*val naturalGreaterEqual : natural -> natural -> bool*)

(*val naturalCompare : natural -> natural -> ordering*)

definition instance_Basic_classes_Ord_Num_natural_dict  :: "(nat)Ord_class "  where 
     " instance_Basic_classes_Ord_Num_natural_dict = ((|

  compare_method = (genericCompare (op<) (op=)),

  isLess_method = (op<),

  isLessEqual_method = (op \<le>),

  isGreater_method = (op>),

  isGreaterEqual_method = (op \<ge>)|) )"


(*val naturalAdd : natural -> natural -> natural*)

definition instance_Num_NumAdd_Num_natural_dict  :: "(nat)NumAdd_class "  where 
     " instance_Num_NumAdd_Num_natural_dict = ((|

  numAdd_method = (op+)|) )"


(*val naturalMinus : natural -> natural -> natural*)

definition instance_Num_NumMinus_Num_natural_dict  :: "(nat)NumMinus_class "  where 
     " instance_Num_NumMinus_Num_natural_dict = ((|

  numMinus_method = (op-)|) )"


(*val naturalSucc : natural -> natural*)
(*let naturalSucc n = (Instance_Num_NumAdd_Num_natural.+) n 1*)
definition instance_Num_NumSucc_Num_natural_dict  :: "(nat)NumSucc_class "  where 
     " instance_Num_NumSucc_Num_natural_dict = ((|

  succ_method = Suc |) )"


(*val naturalPred : natural -> natural*)
definition instance_Num_NumPred_Num_natural_dict  :: "(nat)NumPred_class "  where 
     " instance_Num_NumPred_Num_natural_dict = ((|

  pred_method = (\<lambda> n. n -( 1 :: nat))|) )"


(*val naturalMult : natural -> natural -> natural*)

definition instance_Num_NumMult_Num_natural_dict  :: "(nat)NumMult_class "  where 
     " instance_Num_NumMult_Num_natural_dict = ((|

  numMult_method = (op*)|) )"



(*val naturalPow : natural -> nat -> natural*)

definition instance_Num_NumPow_Num_natural_dict  :: "(nat)NumPow_class "  where 
     " instance_Num_NumPow_Num_natural_dict = ((|

  numPow_method = (op^)|) )"


(*val naturalDiv : natural -> natural -> natural*)

definition instance_Num_NumIntegerDivision_Num_natural_dict  :: "(nat)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_Num_natural_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_Num_natural_dict  :: "(nat)NumDivision_class "  where 
     " instance_Num_NumDivision_Num_natural_dict = ((|

  numDivision_method = (op div)|) )"


(*val naturalMod : natural -> natural -> natural*)

definition instance_Num_NumRemainder_Num_natural_dict  :: "(nat)NumRemainder_class "  where 
     " instance_Num_NumRemainder_Num_natural_dict = ((|

  mod_method = (op mod)|) )"


(*val naturalMin : natural -> natural -> natural*)

(*val naturalMax : natural -> natural -> natural*)

definition instance_Basic_classes_OrdMaxMin_Num_natural_dict  :: "(nat)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_Num_natural_dict = ((|

  max_method = max,

  min_method = min |) )"



(* ----------------------- *)
(* int                     *)
(* ----------------------- *)

(*val intFromNumeral : numeral -> int*)

(*val intEq : int -> int -> bool*)

(*val intLess : int -> int -> bool*)
(*val intLessEqual : int -> int -> bool*)
(*val intGreater : int -> int -> bool*)
(*val intGreaterEqual : int -> int -> bool*)

(*val intCompare : int -> int -> ordering*)

definition instance_Basic_classes_Ord_Num_int_dict  :: "(int)Ord_class "  where 
     " instance_Basic_classes_Ord_Num_int_dict = ((|

  compare_method = (genericCompare (op<) (op=)),

  isLess_method = (op<),

  isLessEqual_method = (op \<le>),

  isGreater_method = (op>),

  isGreaterEqual_method = (op \<ge>)|) )"


(*val intNegate : int -> int*)

definition instance_Num_NumNegate_Num_int_dict  :: "(int)NumNegate_class "  where 
     " instance_Num_NumNegate_Num_int_dict = ((|

  numNegate_method = (\<lambda> i. - i)|) )"


(*val intAbs : int -> int*) (* TODO: check *)

definition instance_Num_NumAbs_Num_int_dict  :: "(int)NumAbs_class "  where 
     " instance_Num_NumAbs_Num_int_dict = ((|

  abs_method = abs |) )"


(*val intAdd : int -> int -> int*)

definition instance_Num_NumAdd_Num_int_dict  :: "(int)NumAdd_class "  where 
     " instance_Num_NumAdd_Num_int_dict = ((|

  numAdd_method = (op+)|) )"


(*val intMinus : int -> int -> int*)

definition instance_Num_NumMinus_Num_int_dict  :: "(int)NumMinus_class "  where 
     " instance_Num_NumMinus_Num_int_dict = ((|

  numMinus_method = (op-)|) )"


(*val intSucc : int -> int*)
definition instance_Num_NumSucc_Num_int_dict  :: "(int)NumSucc_class "  where 
     " instance_Num_NumSucc_Num_int_dict = ((|

  succ_method = (\<lambda> n. n +( 1 :: int))|) )"


(*val intPred : int -> int*)
definition instance_Num_NumPred_Num_int_dict  :: "(int)NumPred_class "  where 
     " instance_Num_NumPred_Num_int_dict = ((|

  pred_method = (\<lambda> n. n -( 1 :: int))|) )"


(*val intMult : int -> int -> int*)

definition instance_Num_NumMult_Num_int_dict  :: "(int)NumMult_class "  where 
     " instance_Num_NumMult_Num_int_dict = ((|

  numMult_method = (op*)|) )"



(*val intPow : int -> nat -> int*)

definition instance_Num_NumPow_Num_int_dict  :: "(int)NumPow_class "  where 
     " instance_Num_NumPow_Num_int_dict = ((|

  numPow_method = (op^)|) )"


(*val intDiv : int -> int -> int*)

definition instance_Num_NumIntegerDivision_Num_int_dict  :: "(int)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_Num_int_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_Num_int_dict  :: "(int)NumDivision_class "  where 
     " instance_Num_NumDivision_Num_int_dict = ((|

  numDivision_method = (op div)|) )"


(*val intMod : int -> int -> int*)

definition instance_Num_NumRemainder_Num_int_dict  :: "(int)NumRemainder_class "  where 
     " instance_Num_NumRemainder_Num_int_dict = ((|

  mod_method = (op mod)|) )"


(*val intMin : int -> int -> int*)

(*val intMax : int -> int -> int*)

definition instance_Basic_classes_OrdMaxMin_Num_int_dict  :: "(int)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_Num_int_dict = ((|

  max_method = max,

  min_method = min |) )"


(* ----------------------- *)
(* int32                   *)
(* ----------------------- *)
(*val int32FromNumeral : numeral -> int32*)

(*val int32Eq : int32 -> int32 -> bool*)

(*val int32Less : int32 -> int32 -> bool*)
(*val int32LessEqual : int32 -> int32 -> bool*)
(*val int32Greater : int32 -> int32 -> bool*)
(*val int32GreaterEqual : int32 -> int32 -> bool*)

(*val int32Compare : int32 -> int32 -> ordering*)

definition instance_Basic_classes_Ord_Num_int32_dict  :: "( 32 word)Ord_class "  where 
     " instance_Basic_classes_Ord_Num_int32_dict = ((|

  compare_method = (genericCompare word_sless (op=)),

  isLess_method = word_sless,

  isLessEqual_method = word_sle,

  isGreater_method = (\<lambda> x y. word_sless y x),

  isGreaterEqual_method = (\<lambda> x y. word_sle y x)|) )"


(*val int32Negate : int32 -> int32*)

definition instance_Num_NumNegate_Num_int32_dict  :: "( 32 word)NumNegate_class "  where 
     " instance_Num_NumNegate_Num_int32_dict = ((|

  numNegate_method = (\<lambda> i. - i)|) )"


(*val int32Abs : int32 -> int32*)
definition int32Abs  :: " 32 word \<Rightarrow> 32 word "  where 
     " int32Abs i = ( (if word_sle(((word_of_int 0) ::  32 word)) i then i else - i))"


definition instance_Num_NumAbs_Num_int32_dict  :: "( 32 word)NumAbs_class "  where 
     " instance_Num_NumAbs_Num_int32_dict = ((|

  abs_method = int32Abs |) )"



(*val int32Add : int32 -> int32 -> int32*)

definition instance_Num_NumAdd_Num_int32_dict  :: "( 32 word)NumAdd_class "  where 
     " instance_Num_NumAdd_Num_int32_dict = ((|

  numAdd_method = (op+)|) )"


(*val int32Minus : int32 -> int32 -> int32*)

definition instance_Num_NumMinus_Num_int32_dict  :: "( 32 word)NumMinus_class "  where 
     " instance_Num_NumMinus_Num_int32_dict = ((|

  numMinus_method = (op-)|) )"


(*val int32Succ : int32 -> int32*)

definition instance_Num_NumSucc_Num_int32_dict  :: "( 32 word)NumSucc_class "  where 
     " instance_Num_NumSucc_Num_int32_dict = ((|

  succ_method = (\<lambda> n. n +((word_of_int 1) ::  32 word))|) )"


(*val int32Pred : int32 -> int32*)
definition instance_Num_NumPred_Num_int32_dict  :: "( 32 word)NumPred_class "  where 
     " instance_Num_NumPred_Num_int32_dict = ((|

  pred_method = (\<lambda> n. n -((word_of_int 1) ::  32 word))|) )"


(*val int32Mult : int32 -> int32 -> int32*)

definition instance_Num_NumMult_Num_int32_dict  :: "( 32 word)NumMult_class "  where 
     " instance_Num_NumMult_Num_int32_dict = ((|

  numMult_method = (op*)|) )"



(*val int32Pow : int32 -> nat -> int32*)

definition instance_Num_NumPow_Num_int32_dict  :: "( 32 word)NumPow_class "  where 
     " instance_Num_NumPow_Num_int32_dict = ((|

  numPow_method = (op^)|) )"


(*val int32Div : int32 -> int32 -> int32*)

definition instance_Num_NumIntegerDivision_Num_int32_dict  :: "( 32 word)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_Num_int32_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_Num_int32_dict  :: "( 32 word)NumDivision_class "  where 
     " instance_Num_NumDivision_Num_int32_dict = ((|

  numDivision_method = (op div)|) )"


(*val int32Mod : int32 -> int32 -> int32*)

definition instance_Num_NumRemainder_Num_int32_dict  :: "( 32 word)NumRemainder_class "  where 
     " instance_Num_NumRemainder_Num_int32_dict = ((|

  mod_method = (op mod)|) )"


(*val int32Min : int32 -> int32 -> int32*)

(*val int32Max : int32 -> int32 -> int32*)

definition instance_Basic_classes_OrdMaxMin_Num_int32_dict  :: "( 32 word)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_Num_int32_dict = ((|

  max_method = ((\<lambda> x y. if (word_sle y x) then x else y)),

  min_method = ((\<lambda> x y. if (word_sle x y) then x else y))|) )"




(* ----------------------- *)
(* int64                   *)
(* ----------------------- *)
(*val int64FromNumeral : numeral -> int64*)

(*val int64Eq : int64 -> int64 -> bool*)

(*val int64Less : int64 -> int64 -> bool*)
(*val int64LessEqual : int64 -> int64 -> bool*)
(*val int64Greater : int64 -> int64 -> bool*)
(*val int64GreaterEqual : int64 -> int64 -> bool*)

(*val int64Compare : int64 -> int64 -> ordering*)

definition instance_Basic_classes_Ord_Num_int64_dict  :: "( 64 word)Ord_class "  where 
     " instance_Basic_classes_Ord_Num_int64_dict = ((|

  compare_method = (genericCompare word_sless (op=)),

  isLess_method = word_sless,

  isLessEqual_method = word_sle,

  isGreater_method = (\<lambda> x y. word_sless y x),

  isGreaterEqual_method = (\<lambda> x y. word_sle y x)|) )"


(*val int64Negate : int64 -> int64*)

definition instance_Num_NumNegate_Num_int64_dict  :: "( 64 word)NumNegate_class "  where 
     " instance_Num_NumNegate_Num_int64_dict = ((|

  numNegate_method = (\<lambda> i. - i)|) )"


(*val int64Abs : int64 -> int64*)
definition int64Abs  :: " 64 word \<Rightarrow> 64 word "  where 
     " int64Abs i = ( (if word_sle(((word_of_int 0) ::  64 word)) i then i else - i))"


definition instance_Num_NumAbs_Num_int64_dict  :: "( 64 word)NumAbs_class "  where 
     " instance_Num_NumAbs_Num_int64_dict = ((|

  abs_method = int64Abs |) )"



(*val int64Add : int64 -> int64 -> int64*)

definition instance_Num_NumAdd_Num_int64_dict  :: "( 64 word)NumAdd_class "  where 
     " instance_Num_NumAdd_Num_int64_dict = ((|

  numAdd_method = (op+)|) )"


(*val int64Minus : int64 -> int64 -> int64*)

definition instance_Num_NumMinus_Num_int64_dict  :: "( 64 word)NumMinus_class "  where 
     " instance_Num_NumMinus_Num_int64_dict = ((|

  numMinus_method = (op-)|) )"


(*val int64Succ : int64 -> int64*)

definition instance_Num_NumSucc_Num_int64_dict  :: "( 64 word)NumSucc_class "  where 
     " instance_Num_NumSucc_Num_int64_dict = ((|

  succ_method = (\<lambda> n. n +((word_of_int 1) ::  64 word))|) )"


(*val int64Pred : int64 -> int64*)
definition instance_Num_NumPred_Num_int64_dict  :: "( 64 word)NumPred_class "  where 
     " instance_Num_NumPred_Num_int64_dict = ((|

  pred_method = (\<lambda> n. n -((word_of_int 1) ::  64 word))|) )"


(*val int64Mult : int64 -> int64 -> int64*)

definition instance_Num_NumMult_Num_int64_dict  :: "( 64 word)NumMult_class "  where 
     " instance_Num_NumMult_Num_int64_dict = ((|

  numMult_method = (op*)|) )"



(*val int64Pow : int64 -> nat -> int64*)

definition instance_Num_NumPow_Num_int64_dict  :: "( 64 word)NumPow_class "  where 
     " instance_Num_NumPow_Num_int64_dict = ((|

  numPow_method = (op^)|) )"


(*val int64Div : int64 -> int64 -> int64*)

definition instance_Num_NumIntegerDivision_Num_int64_dict  :: "( 64 word)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_Num_int64_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_Num_int64_dict  :: "( 64 word)NumDivision_class "  where 
     " instance_Num_NumDivision_Num_int64_dict = ((|

  numDivision_method = (op div)|) )"


(*val int64Mod : int64 -> int64 -> int64*)

definition instance_Num_NumRemainder_Num_int64_dict  :: "( 64 word)NumRemainder_class "  where 
     " instance_Num_NumRemainder_Num_int64_dict = ((|

  mod_method = (op mod)|) )"


(*val int64Min : int64 -> int64 -> int64*)

(*val int64Max : int64 -> int64 -> int64*)

definition instance_Basic_classes_OrdMaxMin_Num_int64_dict  :: "( 64 word)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_Num_int64_dict = ((|

  max_method = ((\<lambda> x y. if (word_sle y x) then x else y)),

  min_method = ((\<lambda> x y. if (word_sle x y) then x else y))|) )"



(* ----------------------- *)
(* integer                 *)
(* ----------------------- *)

(*val integerFromNumeral : numeral -> integer*)

(*val integerEq : integer -> integer -> bool*)

(*val integerLess : integer -> integer -> bool*)
(*val integerLessEqual : integer -> integer -> bool*)
(*val integerGreater : integer -> integer -> bool*)
(*val integerGreaterEqual : integer -> integer -> bool*)

(*val integerCompare : integer -> integer -> ordering*)

definition instance_Basic_classes_Ord_Num_integer_dict  :: "(int)Ord_class "  where 
     " instance_Basic_classes_Ord_Num_integer_dict = ((|

  compare_method = (genericCompare (op<) (op=)),

  isLess_method = (op<),

  isLessEqual_method = (op \<le>),

  isGreater_method = (op>),

  isGreaterEqual_method = (op \<ge>)|) )"


(*val integerNegate : integer -> integer*)

definition instance_Num_NumNegate_Num_integer_dict  :: "(int)NumNegate_class "  where 
     " instance_Num_NumNegate_Num_integer_dict = ((|

  numNegate_method = (\<lambda> i. - i)|) )"


(*val integerAbs : integer -> integer*) (* TODO: check *)

definition instance_Num_NumAbs_Num_integer_dict  :: "(int)NumAbs_class "  where 
     " instance_Num_NumAbs_Num_integer_dict = ((|

  abs_method = abs |) )"


(*val integerAdd : integer -> integer -> integer*)

definition instance_Num_NumAdd_Num_integer_dict  :: "(int)NumAdd_class "  where 
     " instance_Num_NumAdd_Num_integer_dict = ((|

  numAdd_method = (op+)|) )"


(*val integerMinus : integer -> integer -> integer*)

definition instance_Num_NumMinus_Num_integer_dict  :: "(int)NumMinus_class "  where 
     " instance_Num_NumMinus_Num_integer_dict = ((|

  numMinus_method = (op-)|) )"


(*val integerSucc : integer -> integer*)
definition instance_Num_NumSucc_Num_integer_dict  :: "(int)NumSucc_class "  where 
     " instance_Num_NumSucc_Num_integer_dict = ((|

  succ_method = (\<lambda> n. n +( 1 :: int))|) )"


(*val integerPred : integer -> integer*)
definition instance_Num_NumPred_Num_integer_dict  :: "(int)NumPred_class "  where 
     " instance_Num_NumPred_Num_integer_dict = ((|

  pred_method = (\<lambda> n. n -( 1 :: int))|) )"


(*val integerMult : integer -> integer -> integer*)

definition instance_Num_NumMult_Num_integer_dict  :: "(int)NumMult_class "  where 
     " instance_Num_NumMult_Num_integer_dict = ((|

  numMult_method = (op*)|) )"



(*val integerPow : integer -> nat -> integer*)

definition instance_Num_NumPow_Num_integer_dict  :: "(int)NumPow_class "  where 
     " instance_Num_NumPow_Num_integer_dict = ((|

  numPow_method = (op^)|) )"


(*val integerDiv : integer -> integer -> integer*)

definition instance_Num_NumIntegerDivision_Num_integer_dict  :: "(int)NumIntegerDivision_class "  where 
     " instance_Num_NumIntegerDivision_Num_integer_dict = ((|

  div_method = (op div)|) )"


definition instance_Num_NumDivision_Num_integer_dict  :: "(int)NumDivision_class "  where 
     " instance_Num_NumDivision_Num_integer_dict = ((|

  numDivision_method = (op div)|) )"


(*val integerMod : integer -> integer -> integer*)

definition instance_Num_NumRemainder_Num_integer_dict  :: "(int)NumRemainder_class "  where 
     " instance_Num_NumRemainder_Num_integer_dict = ((|

  mod_method = (op mod)|) )"


(*val integerMin : integer -> integer -> integer*)

(*val integerMax : integer -> integer -> integer*)

definition instance_Basic_classes_OrdMaxMin_Num_integer_dict  :: "(int)OrdMaxMin_class "  where 
     " instance_Basic_classes_OrdMaxMin_Num_integer_dict = ((|

  max_method = max,

  min_method = min |) )"




(* ========================================================================== *)
(* Translation between number types                                           *)
(* ========================================================================== *)

(******************)
(* integerFrom... *)
(******************)

(*val integerFromInt : int -> integer*)


(*val integerFromNat : nat -> integer*)

(*val integerFromNatural : natural -> integer*)


(*val integerFromInt32 : int32 -> integer*)


(*val integerFromInt64 : int64 -> integer*)


(******************)
(* naturalFrom... *)
(******************)

(*val naturalFromNat : nat -> natural*)

(*val naturalFromInteger : integer -> natural*)


(******************)
(* intFrom ...    *)
(******************)

(*val intFromInteger : integer -> int*)

(*val intFromNat : nat -> int*)


(******************)
(* natFrom ...    *)
(******************)

(*val natFromNatural : natural -> nat*)

(*val natFromInt : int -> nat*)


(******************)
(* int32From ...  *)
(******************)

(*val int32FromNat : nat -> int32*)

(*val int32FromNatural : natural -> int32*)

(*val int32FromInteger : integer -> int32*)
(*let int32FromInteger i = (
  let abs_int32 = int32FromNatural (naturalFromInteger i) in
  if ((Instance_Basic_classes_Ord_Num_integer.<) i 0) then (Instance_Num_NumNegate_Num_int32.~ abs_int32) else abs_int32 
)*)

(*val int32FromInt : int -> int32*)
(*let int32FromInt i = int32FromInteger (integerFromInt i)*)


(*val int32FromInt64 : int64 -> int32*)
(*let int32FromInt64 i = int32FromInteger (integerFromInt64 i)*)




(******************)
(* int64From ...  *)
(******************)

(*val int64FromNat : nat -> int64*)

(*val int64FromNatural : natural -> int64*)

(*val int64FromInteger : integer -> int64*)
(*let int64FromInteger i = (
  let abs_int64 = int64FromNatural (naturalFromInteger i) in
  if ((Instance_Basic_classes_Ord_Num_integer.<) i 0) then (Instance_Num_NumNegate_Num_int64.~ abs_int64) else abs_int64 
)*)

(*val int64FromInt : int -> int64*)
(*let int64FromInt i = int64FromInteger (integerFromInt i)*)


(*val int64FromInt32 : int32 -> int64*)
(*let int64FromInt32 i = int64FromInteger (integerFromInt32 i)*)


(******************)
(* what's missing *)
(******************)

(*val naturalFromInt : int -> natural*)
(*val naturalFromInt32 : int32 -> natural*)
(*val naturalFromInt64 : int64 -> natural*)


(*val intFromNatural : natural -> int*)
(*val intFromInt32 : int32 -> int*)
(*val intFromInt64 : int64 -> int*)

(*val natFromInteger : integer -> nat*)
(*val natFromInt32 : int32 -> nat*)
(*val natFromInt64 : int64 -> nat*)
end
