import os, random, string


'''
Python 3.6+ based password generator. The main purpose of this program is
to generate new passwords and save them to a text file. Then encrypt that file and/or
decrypt that file for viewing.

Free to use and mod.

'''
password = '1' + "\n"

def passwordGenerator():
    ## TODO:
    # - need to add bad chars to be excluded
    # - add parameter for char length

    length = 32
    chars = string.ascii_letters + string.digits + '!@#$%^&*()'
    random.seed = (os.urandom(1024))
    password = ''.join(random.choice(chars) for i in range(length))

    os.system("echo '%s' | pbcopy" % password)

    print("New generated password: " + password)
    print("Copied to the clipboard!")

def appendToFile():
    ## TODO:
    # - not appending the text to new lines.
    # - Not reading from the password variable

    with open("secret.txt", "ab") as myfile:
        myfile.write(password)

def encryptFile():
    print("encrypt")

def decryptFile():
    print("decrypt")


response = raw_input("Please select an option you wish to perform: [view/gen] ")

if response == "view":
    print("works")

elif response == "gen":
    passwordGenerator()
    appendToFile()

else:
    print("Please select a correct option...")
