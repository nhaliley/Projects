#!/usr/bin/env bash

#Tested and working on 10.14
#Apps going onto the Dock have to be renamed as their app name in the apps directory

appsInstall=('firefox'
	'google-chrome'
	'virtualbox'
	'veracrypt'
	'tunnelblick'
	'sublime-text'
	'iterm2'
	'remote-desktop-manager-free'
	'seafile-client'
	'microsoft-office'
	'microsoft-teams'
	'vlc'
	'xmind'
	'xquartz'
	'wireshark'
	'colloquy')

appsDocked=('Launchpad'
	'App Store'
	'System Preferences'
	'Microsoft Outlook'
	'Microsoft Teams'
	'Microsoft OneNote'
	'Microsoft Word'
	'Microsoft Excel'
	'Microsoft PowerPoint'
	'Firefox'
	'Calculator'
	'VirtualBox'
	'Mission Control'
	'Veracrypt'
	'Sublime Text'
	'iTerm'
	'Seafile Client'
	'XMind'
	'Wireshark'
	'Colloquy'
	'Remote Desktop Manager Free')

appsRemoved=('Automator'
 	'Books'
	'Calendar'
	'Chess'
	'Contacts'
	'Dictionary'
	'FaceTime'
	'Home'
	'Mail'
	'Maps'
	'Messages'
	'News'
	'Notes'
	'Photo\ Booth'
	'Preview'
	'QuickTime\ Player'
	'Reminders'
	'Safari'
	'Siri'
	'Stickies'
	'Stocks'
	'VoiceMemos')


installBrew(){
	echo $line
	echo "  Installing homebrew-cask."
	yes | su $user -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' >/dev/null 2>>/tmp/Brew-Install-Log.txt
	su $user -c "brew tap caskroom/cask" >/dev/null 2>>/tmp/Brew-Install-Log.txt
}
installApps(){
	echo $line
	echo "  Installing applications."
 	for i in "${appsInstall[@]}"; do
 		echo "    $i"
		su $user -c "brew cask install $i --appdir=/Applications" >/dev/null 2>>/tmp/Brew-Install-Log.txt
	done
}

newDock(){
	#Clears the dock
	su $user -c 'defaults write com.apple.dock persistent-apps -array'
	echo $line
	echo "  Adding applications to dock."
	for i in "${appsDocked[@]}"; do
		echo "    $i"
		su $user -c "defaults write com.apple.dock persistent-apps -array-add \"<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$i.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>\"" >/dev/null 2>>/tmp/Brew-Install-Log.txt
	done
	killall Dock
}

removeBloatware(){
	echo $line
	echo "  Removing applications."
	for i in "${appsRemoved[@]}"; do
		echo "    $i"
		rm -rf /Applications/$i.app >/dev/null 2>>/tmp/Brew-Install-Log.txt
	done
}

removeOneDrive(){
	echo $line
	echo "  Removing OneDrive."
	rm -rf /Applications/OneDrive.app >/dev/null 2>>/tmp/Brew-Install-Log.txt
}

checkErrors(){
	 ERROR=$(</tmp/Error)
	 RED='\033[0;31m'
	 NC='\033[0m'
	 if [ ${#ERROR} -gt 0 ]
	 	echo $line
	 then
	 	echo -e "  \033[31;5;4;1mOperation completed with errors.\033[0m"
	 	echo -e "  \033[31mCheck /tmp/Brew-Install-Log.txt\033[0m"
	 else
	 	echo -e "\033[32m  Operation completed without errors.\033[0m"
	 	rm /tmp/Brew-Install-Log.txt
	 fi
}

line="-----------------------------------------------"
clear
if [ "$(csrutil status)" == "System Integrity Protection status: disabled." ]
then
	echo $line
	echo "  System Integrity Protection (SIP) disabled."
	echo "  Proceeding with operation."
	echo $line
	user=$(users)
	echo "  Current user: $user"
	removeBloatware
	installBrew
	installApps
	removeOneDrive
	newDock
	checkErrors
	echo $line
else
	echo $line
	echo "  System Integrity Protection (SIP) enabled."
	echo "  Unable to proceed with operation."
	echo $line
	echo "  Steps to disable..."
	echo "    1. Boot into recovery mode"
	echo "    2. Open terminal through utilities mennu."
	echo "    3. Enter the following command"
	echo "       csrutil disable"
	echo "    4. Reboot and rerun this script."
	echo $line
fi
