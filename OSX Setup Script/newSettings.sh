#!/usr/bin/env bash

#Testing this to see if the screen saver settings will get updated.

'The sudo -v option will prompt for the root password. This will allow for the installer to run as root.

Leave the .dmg plus script file on the desktop or change the dir you wish to work from'

sudo -v

hdiutil attach ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
cd "/Volumes/Command Line Developer Tools"
sudo installer -verbose -pkg "Command Line Tools (macOS Mojave version 10.14).pkg" -target /
printf "\n Removing the dmg file..."
rm ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
printf "Removed! \n"
