// Options:   --no-arrays --no-pointers --no-structs --no-unions --argc --no-bitfields --checksum --comma-operators --compound-assignment --concise --consts --divs --embedded-assigns --pre-incr-operator --pre-decr-operator --post-incr-operator --post-decr-operator --unary-plus-operator --jumps --longlong --int8 --uint8 --no-float --main --math64 --muls --safe-math --no-packed-struct --no-paranoid --no-volatiles --no-volatile-pointers --const-pointers --no-builtins --max-array-dim 1 --max-array-len-per-dim 4 --max-block-depth 1 --max-block-size 4 --max-expr-complexity 1 --max-funcs 1 --max-pointer-depth 2 --max-struct-fields 2 --max-union-fields 2 -o csmith_727.c
#include "csmith.h"


static long __undefined;



static uint64_t g_3 = 18446744073709551615UL;
static int8_t g_4 = 0x65L;
static uint32_t g_5 = 4294967290UL;
static int16_t g_8 = 0xF499L;
static uint8_t g_12 = 255UL;



static const uint32_t  func_1(void);




static const uint32_t  func_1(void)
{ 
    int64_t l_2 = 1L;
    int32_t l_7 = 0xE7F737A9L;
    if (l_2)
    { 
        int64_t l_6 = 1L;
        g_4 ^= g_3;
        g_5 = g_3;
        l_7 = l_6;
    }
    else
    { 
        uint16_t l_9 = 0xFDCBL;
        l_9++;
        l_7 = l_2;
        g_12 = l_9;
    }
    return g_4;
}





int main (int argc, char* argv[])
{
    int print_hash_value = 0;
    if (argc == 2 && strcmp(argv[1], "1") == 0) print_hash_value = 1;
    platform_main_begin();
    crc32_gentab();
    func_1();
    transparent_crc(g_3, "g_3", print_hash_value);
    transparent_crc(g_4, "g_4", print_hash_value);
    transparent_crc(g_5, "g_5", print_hash_value);
    transparent_crc(g_8, "g_8", print_hash_value);
    transparent_crc(g_12, "g_12", print_hash_value);
    platform_main_end(crc32_context ^ 0xFFFFFFFFUL, print_hash_value);
    return 0;
}
