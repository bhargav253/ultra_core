RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

FIRMWARE_OBJS = start.o print.o hello.o

rom.sv: firmware.bin firmware.dump
	python3 makehex.py $< 256 > ../rtl/soc/$@
	emacs --batch ../rtl/soc/$@ -f verilog-batch-indent

firmware.dump: firmware.o
	$(TOOLCHAIN_PREFIX)objdump -D $< >  $@

firmware.bin: firmware.o
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@

firmware.o: $(FIRMWARE_OBJS) sections.ld
	$(TOOLCHAIN_PREFIX)gcc -nostartfiles -mabi=ilp32 -march=rv32im -Tsections.ld -o $@ $(FIRMWARE_OBJS)

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -c -nostartfiles -march=rv32im -mabi=ilp32 -o $@ $<

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c -nostartfiles -march=rv32im -mabi=ilp32 -o $@ $<

clean:
	rm -f *.elf *.bin *.hex *.o *.dump
