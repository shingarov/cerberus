// Options:   --no-arrays --no-pointers --no-structs --no-unions --argc --no-bitfields --checksum --comma-operators --compound-assignment --concise --consts --divs --embedded-assigns --pre-incr-operator --pre-decr-operator --post-incr-operator --post-decr-operator --unary-plus-operator --jumps --longlong --int8 --uint8 --no-float --main --math64 --muls --safe-math --no-packed-struct --no-paranoid --no-volatiles --no-volatile-pointers --const-pointers --no-builtins --max-array-dim 1 --max-array-len-per-dim 4 --max-block-depth 1 --max-block-size 4 --max-expr-complexity 1 --max-funcs 1 --max-pointer-depth 2 --max-struct-fields 2 --max-union-fields 2 -o csmith_404.c
#include "csmith.h"


static long __undefined;



static uint32_t g_2 = 0xD41E5596L;
static uint8_t g_3 = 1UL;
static uint64_t g_8 = 18446744073709551615UL;
static uint64_t g_9 = 0x095A97963BA20B95LL;



static int32_t  func_1(void);




static int32_t  func_1(void)
{ 
    uint8_t l_6 = 7UL;
    if (g_2)
    { 
        ++g_3;
        return l_6;
    }
    else
    { 
        uint32_t l_7 = 0x6A756A33L;
        g_8 = l_7;
        g_9 = 0x0011151CL;
        return g_8;
    }
}





int main (int argc, char* argv[])
{
    int print_hash_value = 0;
    if (argc == 2 && strcmp(argv[1], "1") == 0) print_hash_value = 1;
    platform_main_begin();
    crc32_gentab();
    func_1();
    transparent_crc(g_2, "g_2", print_hash_value);
    transparent_crc(g_3, "g_3", print_hash_value);
    transparent_crc(g_8, "g_8", print_hash_value);
    transparent_crc(g_9, "g_9", print_hash_value);
    platform_main_end(crc32_context ^ 0xFFFFFFFFUL, print_hash_value);
    return 0;
}
