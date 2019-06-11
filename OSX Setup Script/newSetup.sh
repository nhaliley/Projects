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

echo -m "Name this MacBook Pro (MBP-1): "
read name

#change the units name, host name, and local hostname.
scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

#Flushing the DNS cache
dscacheutil -flushcache
echo "Unit renamed to $name"

configurations(){
  printf "Turning off spotlight suggestions"
  sudo mdutil -a -i socketfilterfw

  printf "Enabling password after screen saver"
  defaults write com.apple.screensaver askForPassword -bool true

  printf "Setting the delay to immediate"
  defaults write com.apple.screensaver askForPasswordDelay 0

  printf "Setting idle time top 15 minutes"
  defaults -currentHost write com.apple.screensaver idleTime 900

  printf "Setting up automatic updates"
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled YES

  #Setting up the top left hot corner to put the display to sleep
  printf "Setting up top left hot corner"
  defaults write com.apple.dock wvous-tl-corner -int 10
  defaults write com.apple.dock wvous-tl-modifier -int 0

  killall Dock

  #  This does not work. The images get moved and renamed but the wallpaper stays the same.
  #  printf "New wallpaper incoming"
  #  sudo mv /Library/Desktop\ Pictures/Mojave.heic Backup.heic
  #  sudo mv ~/Desktop/Moon.jpg /Library/Desktop\ Pictures/Moon.jpg
  #  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "~/Desktop/wallpaper.jpg"'
}

configurations

print "\n Setting up firewall \n"
bash ./firewallSetup.sh

print "\n Installing Brew \n"
bash ./brewInstall.sh

print "\n Installing CLI Developer Tools \n"
bash ./installCLITools.sh
