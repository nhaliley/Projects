#!/usr/bin/env bash

"Tested and working on 10.14

Drop the DMG file on the desktop or change the dir working from in the script"
cliDmgFiles(){

  hdiutil attach ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
  cd "/Volumes/Command Line Developer Tools"
  sudo installer -verbose -pkg "Command Line Tools (macOS Mojave version 10.14).pkg" -target /
  printf "\n Removing the dmg file..."
  rm ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
  printf "Removed! \n"

}

cliDmgFiles
