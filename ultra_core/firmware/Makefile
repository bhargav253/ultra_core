RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

firmware.hex: firmware.bin
	python3 makehex.py $< 2048 > $@

firmware.bin: start.o
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@

start.o: start.S
	$(TOOLCHAIN_PREFIX)gcc -nostartfiles -march=rv32im -mabi=ilp32 -Tsections.ld -o $@ $<

clean:
	rm -f *.elf *.bin *.hex *.o
