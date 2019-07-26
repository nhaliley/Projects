import cryptography
from cryptography.fernet import Fernet
import base64
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

key = ''

#user defined password to create a key with. This code is off a blog...
def keyGenerator():
    global key

    input = raw_input("Password to encrypt/decrypt files with: ")
    password = input.encode() # Convert to type bytes
    salt = b'salt_' # CHANGE THIS - recommend using a key from os.urandom(16), must be of type bytes
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
        backend=default_backend()
    )
    key = base64.urlsafe_b64encode(kdf.derive(password)) # Can only use kdf once
    print(key)

def saveToFile():
    global key

    keyFile = open('key.key', 'wb')
    keyFile.write(key) # The key is type bytes still
    keyFile.close()

def setup():
    keyGenerator()
    saveToFile()
