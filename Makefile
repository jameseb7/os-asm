AS := nasm
LD := /usr/local/cross/bin/i586-elf-ld

ASFLAGS := -w+all -w+error

OBJECTS := loader.o kernel_output.o

DISK := floppy.img
LOOP := /dev/loop0
MNT  := /mnt/floppy

.PHONY: all install

all: kernel.bin

kernel.bin: linkscript.ld $(OBJECTS)
	@$(LD) -T linkscript.ld -o $@ $(OBJECTS)

%.o: %.asm
	@$(AS) -f elf32 -o $@ $(ASFLAGS) $<

install:
	@losetup $(LOOP) $(DISK); \
	mount $(LOOP) $(MNT); \
	cp ./kernel.bin $(MNT)/boot/; \
	umount $(LOOP); \
	losetup -d $(LOOP)
