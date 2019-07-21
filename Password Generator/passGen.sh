#! /bin/bash

#Random password generator that copies to a clipboard

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
  rm yeet.txt

fi
