#include "cerberus.h"
/* Generated by CIL v. 1.7.3 */
/* print_CIL_Input is false */

struct E {
   int p ;
   struct E *n ;
};
typedef struct E *EP;
struct C {
   EP x ;
   short cn ;
   short cp ;
};
typedef struct C *CP;
CP ( __attribute__((__noinline__)) foo)(CP h , EP x ) 
{ 
  EP pl ;
  EP *pa ;
  EP nl ;
  EP *na ;
  EP n ;

  {
  pl = 0;
  pa = & pl;
  nl = 0;
  na = & nl;
  while (x) {
    n = x->n;
    if ((x->p & 1) == 1) {
      h->cp = (short )((int )h->cp + 1);
      *pa = x;
      pa = & (*pa)->n;
    } else {
      h->cn = (short )((int )h->cn + 1);
      *na = x;
      na = & (*na)->n;
    }
    x = n;
  }
  *pa = nl;
  *na = 0;
  h->x = pl;
  return (h);
}
}
extern int ( /* missing proto */  __builtin_abort)() ;
int main(void) 
{ 
  struct C c ;
  struct E e[2] ;

  {
  c.x = 0;
  c.cn = 0;
  c.cp = 0;
  e[0].p = 0;
  e[0].n = & e[1];
  e[1].p = 1;
  e[1].n = 0;
  foo(& c, & e[0]);
  if ((int )c.cn != 1 || (int )c.cp != 1) {
    __builtin_abort();
  }
  if ((unsigned long )c.x != (unsigned long )(& e[1])) {
    __builtin_abort();
  }
  if ((unsigned long )e[1].n != (unsigned long )(& e[0])) {
    __builtin_abort();
  }
  if (e[0].n) {
    __builtin_abort();
  }
  return (0);
}
}
