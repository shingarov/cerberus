struct int_list_items {
  int iv;
  struct int_list_items* next;
};

predicate {integer len} IntList(pointer l) {
  if ( l == NULL ) {
    return { len = 0 } ;
  } else {
    let Head_item = Owned<struct int_list_items>(l) ;
    let Tail = IntList(Head_item.value.next) ;
    return { len = Tail.len + 1 } ;
  }
}
