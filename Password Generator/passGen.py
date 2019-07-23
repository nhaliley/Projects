import os, random, string


'''
Python 3.6+ based password generator. The main purpose of this program is
to generate new passwords and save them to a text file. Then encrypt that file and/or
decrypt that file for viewing.

Free to use and mod.

'''

password = ''

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
    print("encrypt")

def decryptFile():
    print("decrypt")


response = raw_input("Please select an option you wish to perform: [view/gen] ")

if response == "view":
    decryptFile()
    openFile()

elif response == "gen":
    passwordGenerator()
    appendToFile()
    encryptFile()

else:
    print("Please select a correct option...")
