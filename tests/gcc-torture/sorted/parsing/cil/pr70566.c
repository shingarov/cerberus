#include "cerberus.h"
/* Generated by CIL v. 1.7.3 */
/* print_CIL_Input is false */

struct mystruct {
   unsigned int f1 : 1 ;
   unsigned int f2 : 1 ;
   unsigned int f3 : 1 ;
};
void ( __attribute__((__noinline__)) myfunc)(int a , void *b ) 
{ 


  {
  return;
}
}
int ( __attribute__((__noinline__)) myfunc2)(void *a ) 
{ 


  {
  return (0);
}
}
extern int ( /* missing proto */  __builtin_abort)() ;
static void set_f2(struct mystruct *user , int f2 ) 
{ 
  int tmp ;

  {
  if (user->f2 != (unsigned int )f2) {
    tmp = myfunc2(0);
    myfunc(tmp, 0);
  } else {
    __builtin_abort();
  }
  return;
}
}
void ( __attribute__((__noinline__)) foo)(void *data ) 
{ 
  struct mystruct *user ;

  {
  user = data;
  if (! user->f2) {
    set_f2(user, 1);
  }
  return;
}
}
int main(void) 
{ 
  struct mystruct a ;

  {
  a.f1 = 1;
  a.f2 = 0;
  foo(& a);
  return (0);
}
}
