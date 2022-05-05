// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "firmware.h"

void hello(void)
{
  print_str("hello world; how is it going\r\n");
  //char ret_chr;
  //ret_chr = get_chr();
  //print_chr(ret_chr);    
}
