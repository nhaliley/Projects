#!/usr/bin/env bash


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
