#!/usr/bin/env bash

"Tested and working on 10.14

Apps going onto the Dock have to be renamed as their app name in the apps directory
"

apps=('flux' 'firefox' 'veracrypt' 'sublime-text' 'iterm' 'seafile-client'
'xmind' 'wireshark' 'colloquy')

appsDocked=('Flux' 'Firefox' 'Veracrypt' 'Sublime Text' 'iTerm' 'Seafile Client'
'XMind' 'Wireshark' 'Colloquy')

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask

installApps(){
  printf "Apps incoming...\n"

  for i in "${apps[@]}"; do
    #brew cask install --appdir=/Applications
    brew cask install $i --appdir=/Applications
  done
}

newDock(){
  #Clears the dock
  defaults write com.apple.dock persistent-apps -array
  killall Dock

  #loops through the apps array to add them to the dock
  for i in "${appsDocked[@]}"; do
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$i.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    killall Dock
  done
}

#calling the functions back
installApps
newDock
