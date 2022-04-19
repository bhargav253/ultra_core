RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

rom.sv: firmware.bin firmware.dump
	python3 makehex.py $< 256 > ../rtl/soc/$@
	emacs --batch ../rtl/soc/$@ -f verilog-batch-indent

firmware.dump: start.o
	$(TOOLCHAIN_PREFIX)objdump -D $< >  $@

firmware.bin: start.o
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -nostartfiles -march=rv32im -mabi=ilp32 -Tsections.ld -o $@ $<

clean:
	rm -f *.elf *.bin *.hex *.o *.dump
