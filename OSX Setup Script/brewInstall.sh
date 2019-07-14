#!/usr/bin/env bash

#Tested and working on 10.14
#Apps going onto the Dock have to be renamed as their app name in the apps directory
#Create a log file at /tmp/Brew-Install-Log.txt
#preReq function is required to install apps since it grabs the current user (should be root).

main(){
	defineColors
	preReqs
	removeBloatware
	installApps
	removeOneDrive
	newDock
	checkErrors
}

appsInstall=('homebrew-cask'
	'atom'
	'colloquy'
	'firefox'
	'google-chrome'
	'iterm2'
	'microsoft-office'
	'microsoft-teams'
	'remote-desktop-manager-free'
	'seafile-client'
	'sublime-text'
	'tunnelblick'
	'veracrypt'
	'virtualbox'
	'vlc'
	'wireshark'
	'xmind'
	'xquartz')

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
	'Google Chrome'
	'Calculator'
	'VirtualBox'
	'Mission Control'
	'Veracrypt'
	'Atom'
	'Sublime Text'
	'Seafile Client'
	'XMind'
	'Wireshark'
	'Colloquy'
	'Remote Desktop Manager Free'
	'iTerm'
	'Utilities/Terminal')

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
	'Photo Booth'
	'Preview'
	'QuickTime Player'
	'Reminders'
	'Safari'
	'Siri'
	'Stickies'
	'Stocks'
	'VoiceMemos')

installApps(){
	line
	echo -e "  \033[93mInstalling applications.\033[0m"
 	for i in "${appsInstall[@]}"; do
 		echo -e "   $yellow ➔ $white $i"
 		if [ "$i" == "homebrew-cask" ]
 		then
 			yes | su $user -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' >/dev/null 2>>/tmp/Brew-Install-Log.txt
			su $user -c "brew tap caskroom/cask" >/dev/null
 		else
 			yes | su $user -c "brew cask install $i --appdir=/Applications" >/dev/null 2>>/tmp/Brew-Install-Log.txt
 		fi
	done
}

newDock(){
	line
	#Clears the dock
	su $user -c 'defaults write com.apple.dock persistent-apps -array'
	echo -e "  \033[93mAdding applications to dock.\033[0m"
	for i in "${appsDocked[@]}"; do
		echo -e "   $yellow ➔ $white $i"
		su $user -c "defaults write com.apple.dock persistent-apps -array-add \"<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$i.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>\"" >/dev/null 2>>/tmp/Brew-Install-Log.txt
	done
	killall Dock
}

removeBloatware(){
	line
	echo -e " $yellow Uninstalling applications.$white"
	for i in "${appsRemoved[@]}"; do
		echo -e "   $yellow ➔ $white $i"
		rm -rf /Applications/"${i}".app >/dev/null 2>>/tmp/Brew-Install-Log.txt
	done
}

removeOneDrive(){
	line
	echo -e "$yellow  Uninstalling OneDrive.$white"
	rm -rf /Applications/OneDrive.app >/dev/null 2>>/tmp/Brew-Install-Log.txt
}

checkErrors(){
	line
	ERROR=$(echo $(</tmp/Brew-Install-Log.txt) | sed -e 's/Updating Homebrew...//g' -e 's/Cloning into.*//g' -e 's/Checking out files.*//g')
	size=$(echo -n $ERROR | wc -m)
	if [ $size -gt 0 ]
	then
		echo -e "  ${redBU}Operation completed with errors.$white"
	 	echo -e " $red Check /tmp/Brew-Install-Log.txt$white"
	else
	 	echo -e " ${greenB} Operation completed without errors.$white"
	 	rm /tmp/Brew-Install-Log.txt
	fi
	line
}

preReqs(){
	clear
	rm /tmp/Brew-Install-Log.txt &> /dev/null
	echo ""
	line
	echo -e "$yellow  Prereq checks...$white"
	if [ "$(csrutil status)" == "System Integrity Protection status: disabled." ]
	then
		echo -e "$green    System Integrity Protection (SIP) disabled.$white"
	else
		line
		echo -e "$red    System Integrity Protection (SIP) enabled.$white"
		echo  -e "$red    Unable to proceed with operation. $white"
		line
		echo "  Steps to disable..."
		echo "      1. Boot into recovery mode"
		echo "      2. Open terminal through utilities mennu."
		echo "      3. Enter the following command"
		echo "         csrutil disable"
		echo "      4. Reboot and run this script again."
		line
		exit
	fi
	if [ "$(whoami)" != "root" ]
	then
		echo -e "$red    Non root user! Execute script with sudo.$white"
		line
		exit
	else
		echo -e "$green    Root detected.$white"
	fi
	user=$(users)
	echo -e "$green    User profile(s) effected:$yellow $user$white"
}

defineColors(){
	red="\033[31m"
	green="\033[92m"
	yellow="\033[93m"
	white="\033[0m"
	redBU="\033[31;4;1m"
	greenB="\033[32;1m"
	underline="\033[4m"
}

line(){
	echo -e "$underline                                                     $white"
	echo ""
}

main
