import random
import string
import os

#These imports are needed for crypto
import cryptography
from cryptography.fernet import Fernet
import base64
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC


'''
Python based password generator. The main purpose of this program is
to generate new passwords and save them to a text file. Then encrypt that file and/or
decrypt that file for viewing.

Free to use and mod.

Credit to: https://nitratine.net/blog/post/encryption-and-decryption-in-python/
For help with encryption and decryption code

'''

'''
TODO:
[] Save the generated key to a file and use that as an input instead a global variable
[] Create a separate file to run the crypto functions
[] Run the logic in a loop until user states to exit
[] Sudo password to gen key?
'''


password = ''
key = ''

def passwordGenerator():
    ## TODO:
    # - need to add bad chars to be excluded
    # - add parameter for char length
    global password

    length = 32
    chars = string.ascii_letters + string.digits + '!@#$%^&*()'
    random.seed = (os.urandom(1024))
    password = ''.join(random.choice(chars) for i in range(length))

    os.system("echo '%s' | pbcopy" % password)
    print("New generated password: " + password)
    print("Copied to the clipboard!")

def appendToFile():
    global password

    # The bottom line writes and appends to the text file
    # secretFile is a var
    with open("secret.txt", "ab") as secretFile:
        secretFile.write(password + "\n")

def openFile():
    # var 'file' opens the secret text with option r for read. then we print
    # the file using file.read()
    file = open("secret.txt", "r")
    print(file.read())

def encryptFile():
    global key

    file = 'secret.txt'
    output = 'test.encrypted'

    with open(file, 'rb') as x:
        data = x.read()

        fernet = Fernet(key)
        encrypted = fernet.encrypt(data)

    with open(output, 'wb') as y:
        y.write(encrypted)

    os.remove("secret.txt")

def decryptFile():
    global key

    file = 'test.encrypted'
    output = 'secret.txt'

    with open(file, 'rb') as x:
        data = x.read()

    fernet = Fernet(key)
    encrypted = fernet.decrypt(data)

    with open(output, 'wb') as x:
        x.write(encrypted)

    os.remove("test.encrypted")

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



response = raw_input("Please select an option you wish to perform: [view/gen/exit] ")

if response == "view":
    keyGenerator()
    decryptFile()
    openFile()

elif response == "gen":
    passwordGenerator()
    appendToFile()
    keyGenerator()
    encryptFile()

elif response == "exit"
    encryptFile()

elif response == "keygen":
    keyGenerator()

else:
    print("Please select a correct option...")
