import random
import string
import os
import sys
import shutil

#These imports are needed for crypto
import cryptography
from cryptography.fernet import Fernet
import base64
import os
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

from keyGen import *

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
[] Logic is broken. Maybe it needs be a loop and at the start of a loop it decrypts the file
prior to running? Maybe this will fix this isue?
'''

website = ''
user = ''
password = ''
key = ''
loopInput = ''
arg = sys.argv[1]

def key():
    global key

    keyFile = open('key.key', 'rb')
    key = keyFile.read() # The key will be type bytes
    keyFile.close()

def passwordGenerator():
    ## TODO:
    # - need to add bad chars to be excluded
    # - add parameter for char length
    global password
    global user
    global website

    length = 32
    chars = string.ascii_letters + string.digits + '!@#$%^&*()'
    random.seed = (os.urandom(1024))
    password = ''.join(random.choice(chars) for i in range(length))

    os.system("echo '%s' | pbcopy" % password)

    website = raw_input("Enter the website \n")
    user = raw_input("Enter the user for " + website + "\n")

    print("New generated password for " + website + " is: " + password)
    print("Copied to the clipboard!")

def appendToFile():
    global password

    # The bottom line writes and appends to the text file
    # secretFile is a var
    with open("secret.txt", "ab") as secretFile:
        secretFile.write(website + " : " + user + " : " + password + "\n")

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

#Copies the encrypted file onto the desktop
def backup():
    newLocation = shutil.copy('test.encrypted', '/Users/nazariyhaliley/Desktop')

def mainLoop():

    while loopInput != "exit":

        response = raw_input("Please select an option you wish to perform: [view/gen/exit] \n")

        if response == "view":
            openFile()

        elif response == "gen":
            passwordGenerator()
            appendToFile()

        elif response == "exit":
            print("Encrypting the file... \n")
            encryptFile()
            break

        else:
            print("Please select a correct option...")

def main():
    if arg == "-setup":
         setup()
         key()
         encryptFile()

    elif arg == "-run":
        key()
        decryptFile()
        mainLoop()

    elif arg =="-backup":
        backup()

    else:
        print("Quiting...")

if __name__ == '__main__':
    main()
