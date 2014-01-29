AS := nasm
LD := /usr/local/cross/bin/i586-elf-ld

ASFLAGS := -w+all -w+error

SOURCES := $(wildcard *.asm)
DEPENDS := $(SOURCES:.asm=.dep)
OBJECTS := $(SOURCES:.asm=.o)

DISK := floppy.img
LOOP := /dev/loop0
MNT  := /mnt/floppy

.PHONY: all install

all: kernel.bin

kernel.bin: linkscript.ld $(OBJECTS)
	$(LD) -T linkscript.ld -o $@ $(OBJECTS)

%.o: %.asm
	$(AS) -f elf32 -o $@ $(ASFLAGS) -MD $(*F).dep $<
-include *.dep

install:
	@losetup $(LOOP) $(DISK); \
	mount $(LOOP) $(MNT); \
	cp ./kernel.bin $(MNT)/boot/; \
	umount $(LOOP); \
	losetup -d $(LOOP)
