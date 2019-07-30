Hello!

This is a simple password generator that runs on python. This was for educational purposes and should not be used for actually managing your passwords.

To use this simple run the setup first with:
[python passGen.py -setup]

Once the setup has been ran, you can view and generate passwords with:
[python passGen.py -run]

To use the backup feature, be sure to change the location in the backup function. To make a backup, use:
[python passGen.py -backup]

Issues:
1. The biggest issue is that the key to decrypt and encrypt the file is stored into the key.key file. This poses security risks because an attacker literally has your key.

2. There is an issue where if the script fails, during the main loop, the file will not be encrypted. This results in not being able to run the script again as there is no encrypted file to decrypt. This can be managed by running the setup again.
