.DEFAULT_GOAL := all
.PHONY: build run clean

TARGET1 = lab1-1
TARGET2 = lab1-2

SRC1 = lab1-1.asm
SRC2 = lab1-2.asm

AS = nasm
ASFLAGS = -f elf32
LD = ld
LDFLAGS = -m elf_i386

build: $(TARGET1) $(TARGET2)

$(TARGET1): $(SRC1:.asm=.o)
	$(LD) $(LDFLAGS) $(SRC1:.asm=.o) -o $(TARGET1)

$(TARGET2): $(SRC2:.asm=.o)
	$(LD) $(LDFLAGS) $(SRC2:.asm=.o) -o $(TARGET2)

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

run: build
	@echo "--- Запуск $(TARGET1) ---"
	./$(TARGET1)
	@echo "\n--- Запуск $(TARGET2) ---"
	./$(TARGET2)

clean:
	rm -f *.o $(TARGET1) $(TARGET2)

all:
	make clean
	make build
	make run
