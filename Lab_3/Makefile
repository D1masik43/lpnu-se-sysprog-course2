.DEFAULT_GOAL := all
.PHONY: build run clean

TARGET1 = lab3

SRC1 = lab3.asm

AS = nasm
ASFLAGS = -f elf32 -g
LD = ld
LDFLAGS = -m elf_i386

build: $(TARGET1)

$(TARGET1): $(SRC1:.asm=.o)
	$(LD) $(LDFLAGS) $(SRC1:.asm=.o) -o $(TARGET1)

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

run: build
	@echo "--- Запуск $(TARGET1) ---"
	./$(TARGET1)

debug: build
	@echo "--- GDB Dashboard Debug $(TARGET1) ---"
	gdb -ex "dashboard stack -n 10" \
		-ex "starti" \
		-ex "dashboard memory watch &A 64" \
		-ex "dashboard expressions watch *(short*)&A" \
		-ex "dashboard expressions watch *(char*)&B" \
		-ex "dashboard expressions watch *(char*)&C_val" \
		-ex "dashboard expressions watch *(char*)&D" \
		-ex "dashboard expressions watch *(short*)&E" \
		-ex "dashboard expressions watch *(int*)&X" \
		-ex "dashboard expressions watch (char[11])buffer" \
		./$(TARGET1)

clean:
	rm -f *.o $(TARGET1)

all:
	make clean
	make build
	make run

setup:
	@echo "--- Pulling dashboard ---"
	wget -P ~ https://git.io/.gdbinit
	@echo "--- Done ---"
