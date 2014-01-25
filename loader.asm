        bits 32

        section .data
magic:  equ     0x1BADB002             ;multiboot magic number
flags:  equ     11b   ;multiboot flags - align page, memory map
checksum:       equ -(magic + flags)


        section .bss
stack:  resb 1000h
stack_top:      

        section .text
multiboot_header:
        dd magic
        dd flags
        dd checksum

        
        global loader
loader: 
        cli
        mov esp, stack_top

        mov byte [0xB8000], 'A'
        mov byte [0xB8001], 07h

        cli
        hlt
