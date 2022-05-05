// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"

void print_chr(char ch)
{
  *((volatile uint32_t*)UART_BASE) = ch;
  *((volatile uint32_t*)UART_BASE) = '\n';
}

void print_str(const char *p)
{
  while (*p != 0)
    *((volatile uint32_t*)UART_BASE) = *(p++);
  *((volatile uint32_t*)UART_BASE) = 12;
}

char get_chr()
{
  char value = *(char*)UART_BASE;  
  return value;
}

const char* get_str()
{
  char str[16];
  int i = 0;  
  
  str[i] = *(char*)UART_BASE;  
  
  while (str[i] != '\n') {
    i++;
    str[i] = *(char*)UART_BASE;    
  }

  const char* p = str;
  return p;
}
