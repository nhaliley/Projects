#!/usr/bin/env bash

"Current issues:

-Running this as sudo is required to avoid clicking the ok button to changes being made,
however, this creates an issue where the brewInstall.sh file wont work becasue its ran as sudo. Perhaps theres
a way to have this script execute a CLI command in which that will run a script?
Maybe this?
echo './brewInstall'

-For some reason the hotcorers arent being setup. maybe remove them from a function and run them.

-The last option on the Firewall rules gives back an error. Unknown.

"

sudo -v

echo "Name this MacBook Pro (MBP-1): "
read name

#change the units name, host name, and local hostname.
scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

#Flushing the DNS cache
dscacheutil -flushcache
printf "Unit renamed to $name \n"

configurations(){

  #printf "Turning off spotlight suggestions\n"
  #csrutil disable
  #sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  #csrutil enable

  printf "Enabling password after screen saver\n"
  defaults write com.apple.screensaver askForPassword -bool true

  printf "Setting the delay to immediate\n"
  defaults write com.apple.screensaver askForPasswordDelay 0

  printf "Requiring immidiate password after screen saver"
  sudo osascript -e 'tell application "System Events" to set require password to wake of security preferences to false'

  printf "Setting up automatic updates\n"
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled YES



  #  This does not work. The images get moved and renamed but the wallpaper stays the same.
  #  printf "New wallpaper incoming"
  #  sudo mv /Library/Desktop\ Pictures/Mojave.heic Backup.heic
  #  sudo mv ~/Desktop/Moon.jpg /Library/Desktop\ Pictures/Moon.jpg
  #  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "~/Desktop/wallpaper.jpg"'
}

printf "\n Configuring settings \n"
osascript -e 'tell application "Terminal" to do script "cd ~/Desktop/; ./test.sh"'

printf "\n Setting up firewall \n"
bash ./firewallSetup.sh

printf "\n Installing Brew \n"
osascript -e 'tell application "Terminal" to do script "cd ~/Desktop/; echo -ne '\n' | ./brewInstall.sh"'

printf "\n Installing CLI Developer Tools \n"
bash ./installCLITools.sh
