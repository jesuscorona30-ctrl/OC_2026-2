build: 
	nasm -f elf rep.asm
	ld -m elf_i386 rep.o -o ../../bin/rep.exe ../../lib/libpc_io.a
run:
	./../../bin/rep.exe