OUTPUT_ARCH( "riscv" )
ENTRY(_start)
MEMORY { 
	rom(rwx) : ORIGIN = 0x00000000, LENGTH = 1k
        ram(rwx) : ORIGIN = 0x00000400, LENGTH = 3k
}
SECTIONS {
	.rom : {
                _start*(.text);
		start*(.text);
                . = ALIGN(4);
		*(.text);
        } > rom

        .data : {
          _data_lma = LOADADDR(.data);
          _data = .;
          __global_pointer$ = . ;
          *(.data .data.* )
          *(.sdata .sdata.*)
           . = ALIGN(4);
          _edata = .;
        } >ram AT>rom

        .bss : {
          _bss_start = .;
          *(.bss .bss.*)
           . = ALIGN(4);
          _bss_end = .;
          _end = .;
	  stack_top = .;
        } >ram
}
 
