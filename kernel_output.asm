        bits 32

        section .data

video_memory_start      equ     0xB8000
video_memory_end        equ     video_memory_start + (80*32*2)
        
output_pos:     dd      video_memory_start
        
        global kprint
kprint:
        push    ebp
        mov     ebp, esp
        pusha

        mov     esi, [ebp + 8]    ;set the source to the input string
        mov     edi, [output_pos] ;set the destination to the current video memory position
        mov     dl, 0x07          ;store the output colour for grey on black
        cld                       ;ensure the direction flag is cleared
.loop:
        movsb
        mov [edi], dl
        inc edi
        
        cmp edi, video_memory_end
        jle .check_str_end
        
.wrap_output:
        mov edi, video_memory_start
.check_str_end:
        cmp byte [esi], 0
        jne .loop

        mov [output_pos], edi

        popa
        pop ebp
        ret

        global newline
newline:
        pusha

        mov     eax, [output_pos] ;acquire the current output position
        sub     eax, video_memory_start
        cdq                       ;extend eax to 64 bits across eax and edx
        mov     ecx, 160          ;store the memory line length in a register
        div     ecx               ;get the current line number in eax
        inc     eax               ;increment line number
        mul     ecx               ;expand to an output position
        add     eax, video_memory_start
        mov     [output_pos], eax ;replace the current output position

        popa
        ret

        global clear_screen
clear_screen:
        pusha
        
        mov     dl, 0
        mov     edi, video_memory_start
.loop:   
        mov     [video_memory_start + ecx], dl
        loop    .loop

        popa
        ret
