#! /bin/bash

#Random password generator that copies to a clipboard

printf "Select a length between 10-32. \n"
read pwLength

generator(){
  local result=`openssl rand -base64 $pwLength`
  echo $result | pbcopy
  echo $result
}

printf "Password: $(generator) \n"
printf "Copied to the clipboard!"
