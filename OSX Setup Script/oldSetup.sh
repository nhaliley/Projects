#!/usr/bin/env bash


'Script is inteded to run configuration and setup on new OSX machines.

TODO:
[X] Install FireFox over CLI along with extensions such as:
  - [] LastPass
  - [] uBlock
  - [] TemperData
  - [] AdBock?

[ ] Configure iCloud settings from CLI to disable all. (perhaps not sign into it during setup?)
[ ] Change wallpaper
[ ] Change screensaver
[X] Change the name of the computer with user input
[X] Firewall settings
[X] Change the name of unit
[X] Setup technical user
[ ] Brew install virtual box (issue: Cannot set dev approval from CLI)
[X] Place all apps from brew into the Dock
[X] Add func for custom dmg files to be installed
[X] Hotcorners
[X] Settings for OSX
[X]
'
sudo -v

apps=('flux' 'firefox' 'veracrypt' 'tunnelblick' 'sublime-text' 'iterm2' 'remote-desktop-manager-free' 'seafile-client'
'microsoft-office' 'vlc' 'skype-for-business' 'xmind' 'xquartz' 'wireshark' 'microsoft-teams' 'colloquy')

'
#checks if the user is roor or not...
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root, use sudo "$0" instead" 1>&2
   exit 1
fi
'

echo -m "Name this MacBook Pro (MBP-1): "
read name

#change the units name, host name, and local hostname.
scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

#Flushing the DNS cache
dscacheutil -flushcache
echo "Unit renamed to $name"


firewallSetup(){
  printf "Setting up firewall + settings \n\n"
  printf "Enabling Firewall\n"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

  printf "Blocks all incoming connections\n"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

  printf "Enabling Logging\n"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

  printf "Enabling Stealth Mode\n"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  #(Stealth Mode) Prevents computer from responding to ICMP ping requests and does not answer to
  #connection attempts from a closed TCP or UDP port

  #set whether signed applications are to automatically receive incoming connections or not
  printf "Blocking automatic connections from signed apps\n\n"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
}

configurations(){
  printf "Turning off spotlight suggestions\n"
  sudo mdutil -a -i socketfilterfw

  printf "Enabling password after screen saver\n"
  defaults write com.apple.screensaver askForPassword -bool true

  printf "Setting the delay to immediate\n"
  defaults write com.apple.screensaver askForPasswordDelay 0

  printf "Setting idle time top 15 minutes\n"
  defaults -currentHost write com.apple.screensaver idleTime 900

  printf "Setting up automatic updates\n"
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled YES

  #Setting up the top left hot corner to put the display to sleep
  printf "Setting up top left hot corner\n"
  defaults write com.apple.dock wvous-tl-corner -int 10
  defaults write com.apple.dock wvous-tl-modifier -int 0

  killall Dock

#  This does not work. The images get moved and renamed but the wallpaper stays the same.

#  printf "New wallpaper incoming"
#  sudo mv /Library/Desktop\ Pictures/Mojave.heic Backup.heic
#  sudo mv ~/Desktop/Moon.jpg /Library/Desktop\ Pictures/Moon.jpg
#  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "~/Desktop/wallpaper.jpg"'

}


installBrew(){
  printf "\n Preparing to install Brew \n"

  #installing brew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew tap caskroom/cask
}

installApps(){
  printf "Apps incoming...\n"

  for i in "${apps[@]}"; do
    #brew cask install --appdir=/Applications
    brew cask install $i --appdir=/Applications
  done
}

newDock(){
  #Removes current apps in the dock
  defaults write com.apple.dock persistent-apps -array

  #loops through the apps array to add them to the dock
  for i in "${apps[@]}"; do
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$i.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    killall Dock
  done
}

cliDmgFiles(){

  hdiutil attach ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
  cd "/Volumes/Command Line Developer Tools"
  sudo installer -verbose -pkg "Command Line Tools (macOS Mojave version 10.14).pkg" -target /
  printf "\n Removing the dmg file..."
  rm ~/Desktop/Command_Line_Tools_macOS_10.14_for_Xcode_10.2.1.dmg
  printf "Removed! \n"

}

firewallSetup
configurations

printf "\n Installing brew..."
bash ./brewInstall
#installBrew
#installApps
#newDock
#cliDmgFiles
