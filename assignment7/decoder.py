!/usr/bin/python
from Crypto.Cipher import AES

offset=7
ciph=("\x82\x99\x60\x2d\xd9\x46\x0b\x6b\xf8\x76\xfb\x66\x26\xa9\x88\xe6\xa2\xce\xcb\xd3\x81\x1e\xb7\x0a\x82\x28\x9b\x0f\x07\x37\x68\x93")
obj=AES.new('SecretPassw0rd12', AES.MODE_CBC, 'IVeeeccccttttoor')
t=obj.decrypt(ciph)
initial=""
for x in bytearray(t) :
	initial += '\\x'
	one = '%02x' % (x & 0xff)
	initial += one	
	
print initial[0:-offset*4]
