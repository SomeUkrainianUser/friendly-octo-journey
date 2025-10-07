calc : calc.asm ../stdlib.asm
	nasm -f elf64 calc.asm -o calc.o -g -F dwarf
	ld calc.o -o calc
