// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#ifndef FIRMWARE_H
#define FIRMWARE_H

#include <stdint.h>
#include <stdbool.h>

#define UART_BASE 0x10000000

// print.c
void print_chr(char ch);
void print_str(const char *p);
char get_chr();
const char* get_str();
  
#endif
