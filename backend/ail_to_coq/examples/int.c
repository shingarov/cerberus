#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

long f(int i, char c){
  return i;
}

int main() {
    unsigned char uc; signed char sc; char c;
    unsigned short us; signed short ss; short s;
    unsigned int ui; signed int si; int i;
    unsigned long ul; signed long sl; long l;
    unsigned long long ull; signed long long sll; long long ll;
    _Bool b;
    size_t st; uintptr_t uptr; intptr_t ptr;

    c = 0;

    // test constant modifiers
    ull = 0L;
    ull = 0LL;
    ull = 0ULL;
    ull = 0UL;

    // test promotion
    i = c + c;

    // test conversion
    i = i + ull;

    // test casts
    i = (char) ll;

    // test boolean
    b = true;
    b = false;
    // TODO: look at this, the output here seems wrong (== should operate on i64 and not i32)
    b = l == l;
    b = l + l;

    // test if stmt and assert
    if (l == l) {
        assert(l == l);
    }

    // test function call
    i = f(c, l);

    return 0;
}