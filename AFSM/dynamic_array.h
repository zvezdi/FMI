#pragma once

struct DynamicArray {
  int *arr;
  int size;
  int capacity;
};

void initialize(struct DynamicArray*);
void print(struct DynamicArray*);
void resize(struct DynamicArray*);
void insert(struct DynamicArray*, int);
void delete(struct DynamicArray*);