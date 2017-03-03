#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dynamic_array.h"

void initialize(struct DynamicArray* dynamic_array){
  dynamic_array->size = 0;
  dynamic_array->capacity = 1;
  dynamic_array->arr = (int*) malloc(dynamic_array->capacity * sizeof(int));
};

void print(struct DynamicArray* dynamic_array) {
  printf("%s: %d\n", "Size", dynamic_array->size);  
  printf("%s: %d\n", "Capacity", dynamic_array->capacity);
  printf("%s", "Array content: ");
  for(int index = 0; index < dynamic_array->size; index++){
    printf("%d", dynamic_array->arr[index]);
  };
}

void resize(struct DynamicArray* dynamic_array) {
  dynamic_array->capacity = 2 * dynamic_array->capacity;
  dynamic_array->arr = realloc(dynamic_array->arr, dynamic_array->capacity);
}

void insert(struct DynamicArray* dynamic_array, int element){
  if (dynamic_array->size == dynamic_array->capacity){
    resize(dynamic_array);
  }
  dynamic_array->arr[dynamic_array->size] = element;
  dynamic_array->size = dynamic_array->size + 1;
};

void delete(struct DynamicArray* dynamic_array){
  free(dynamic_array->arr);
}
