bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    A db 10110011b
    B db 00011100b
    C dd 0

; our code starts here
segment code use32 class=code
    start:
        ;bits 16 - 31 of C take value 1 
        or dword[C], 11111111111111110000000000000000b      ;C = 1111 1111 1111 1111 0000 0000 0000 0000 = 4294901760
        
        ;the bits 0-3 of C are the same as the bits 3-6 of B 
        mov al, byte[B]                                     ;al = 0001 1100 = 28
        shr al, 3                                           ;al = 0000 0011 = 3
        and al, 00001111b                                   ;al = 0000 0011
        cbw
        cwde                                                 ;al -> eax
        or dword[C], eax                                   ;C = 1111 1111 1111 1111 0000 0000 0000 0011 = 4294901763
        
        ;the bits 4-7 of C have the value 0 
        and dword[C], 11111111111111111111111100001111   ;C = 1111 1111 1111 1111 0000 0000 0000 0011
        
        ; the bits 8-10 of C have the value 110
        mov ebx, 00000000000000000000011000000000b
        or dword[C], ebx                                   ;C = 1111 1111 1111 1111 0000 0110 0000 0011 = 4294903299
        mov ebx, 0
        mov ebx, 11111111111111111111111011111111b
        and dword[C], ebx
        
        ;the bits 11-15 of C are the same as the bits 0-4 of A
        mov eax, 0
        mov al, byte[A]                                     ;al = 1011 0011 = 179
        cbw
        cwde                                                 ;al -> eax
        shr eax, 11                                         ;eax = 0000 0000 0000 0101 1001 1000 0000 0000 = 366592
        and dword[C], eax                                  ;[C] = 1111 1111 1111 1111 1001 1110 0000 0011 = 4294942211
        mov ecx, dword[C]
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
