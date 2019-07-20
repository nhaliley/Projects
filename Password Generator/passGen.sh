#! /bin/bash

#Random password generator that copies to a clipboard

'
TODO:

[X] Varibale to name text file
[X] Function to encrypt text file
[X] Function to decrypt text file
[X] Function to append into the txt file
[] PGP way of encrypting the file maybe?
[] yeet


'
FILE=secure.txt
printf "Select an option: [gen/view] \n"
read answer

if [[ $answer == "gen" ]]; then
  printf "Select a length between 10-32. \n"
  read pwLength
  openssl rand -base64 $pwLength | pbcopy
  pbpaste >> $FILE
  printf "Copied to the clipboard! \n"

  openssl enc -aes-256-cbc -salt -in $FILE -out file.txt.enc

elif [[ $answer == "view" ]]; then

  openssl enc -aes-256-cbc -d -in file.txt.enc -out yeet.txt
  cat yeet.txt
fi
