#include "dynamic_array.h"

void test_dynamic_array(){
  struct DynamicArray dynamic_array;
  initialize(&dynamic_array);
  insert(&dynamic_array, 5);
  insert(&dynamic_array, 7);
  insert(&dynamic_array, 8);
  print(&dynamic_array);
  delete(&dynamic_array);
}

int main(){
  test_dynamic_array();
  return 0;
}