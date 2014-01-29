        bits 32

        %include "kernel_output.inc"

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
        mov     esp, stack_top

        call    clear_screen

        section .rodata
hello_str:      db      'Hello, world!'
        
        section .text
        
        push    hello_str
        call    kprint
        call    newline
        call    kprint
        add     esp, 4

        cli
        hlt
