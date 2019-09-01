#!/bin/bash

#Tested and working on 10.14
#Apps going onto the Dock have to be renamed as their app name in the apps directory
#Create a log file at /tmp/Brew-Install-Log.txt
#preReq function is required to install apps since it grabs the current user (should be root).

main(){
	defineColors
	preReqs
	removeBloatware
	installApps
	installOfficePackages
	removeOneDrive
	newDock
	settings
	confLittleSnitch
	refreshSys
	checkErrors
}

appsInstall=('homebrew-cask'
	'atom'
	'colloquy'
	'google-chrome'
	'iterm2'
	'remote-desktop-manager-free'
	'seafile-client'
	'little-snitch'
	'sublime-text'
	'tunnelblick'
	'veracrypt'
	'virtualbox'
	'vlc'
	'intellij-idea'
	'wireshark'
	'xmind'
	'deluge'
	'postman'
	'xquartz')

appsDocked=('Launchpad'
	'App Store'
	'System Preferences'
	'Microsoft Outlook'
	'Microsoft Teams'
	'Microsoft OneNote'
	'Microsoft Word'
	'Microsoft Excel'
	'Google Chrome'
	'Calculator'
	'VirtualBox'
	'Mission Control'
	'Veracrypt'
	'Atom'
	'Sublime Text'
	'Seafile Client'
	'intellij-idea'
	'XMind'
	'Wireshark'
	'Colloquy'
	'Remote Desktop Manager Free'
	'iTerm'
	'Utilities/Terminal')

appQuarantine=('Veracrypt'
	'Atom'
	'Sublime Text'
	'Seafile Client'
	'XMind'
	'Wireshark'
	'Colloquy'
	'Remote Desktop Manager Free'
	'iTerm'
	'VirtualBox'
	'Google Chrome')

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
 		if [ "$i" == "homebrew-cask" ]
 		then
 			echo -e "   $yellow ➔ $white $i"
 			yes | su $user -c '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' >/dev/null 2>>/dev/null
			su $user -c "brew tap caskroom/cask" >/dev/null 2>>/dev/null
		elif [ $i == little-snitch ] && [ $TECHUSER == [yY] ]
		then
			echo -e "   $yellow ➔ $white $i"
			yes | su $user -c "brew cask install $i --appdir=/Applications" >/dev/null 2>>/tmp/Brew-Install-Log.txt
 		elif [ "$i" != "little-snitch" ]
 		then
 			echo -e "   $yellow ➔ $white $i"
 			yes | su $user -c "brew cask install $i --appdir=/Applications" >/dev/null 2>>/tmp/Brew-Install-Log.txt
 		fi
	done
}

installOfficePackages(){
	packages=($(ls -d /Volumes/macinstall/Office/*))
	for i in "${packages[@]}"; do
		packagename=$(echo $i | sed 's/.*\///g' | sed 's/.pkg//g' | sed 's/_/ /g')
		echo -e "   $yellow ➔ $white $packagename"
		installer -pkg $i -target / >/dev/null 2>>/tmp/Brew-Install-Log.txt
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
	user=$(users | sed 's/_.* //g')
	echo -e "$green    User profile(s) effected:$yellow $user$white"
	read -s -p "    Enter user $user's password: " PASSWORD
	echo
	read -p "    Enter asset number: " COMPUTERNAME
	COMPUTERNAME="MBP-$COMPUTERNAME"
	read -p "    Tech user? (Y/N): " TECHUSER && [[ $TECHUSER == [yY] || $TECHUSER == [yY][eE][sS] ]]

read -r -p "    Continue? (Y/N): " response
if [[ "$response" != [yY] ]]
then
    exit 0
fi


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

settings(){
	line
	echo -e "$yellow  Configuring...$white"

	#Remove app quarantines
#	echo -e "   $yellow ➔ $white Remove app quarantines..."
#	for i in "${appQuarantine[@]}"; do
#		app=$(echo $i | sed 's| |*|g')
#		echo "$app"
#		xattr -r -d com.apple.quarantine /Applications/$app.app >/dev/null 2>>/tmp/Brew-Install-Log.txt
#	done

	#Set computer name
	echo -e "   $yellow ➔ $white Setting computer name..."
	sudo scutil --set ComputerName $COMPUTERNAME >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#User profile image
	echo -e "   $yellow ➔ $white Prereq checks..."
	dscl . delete /Users/$user jpegphoto >/dev/null 2>>/tmp/Brew-Install-Log.txt
	dscl . delete /Users/$user Picture >/dev/null 2>>/tmp/Brew-Install-Log.txt
	dscl . create /Users/$user Picture "/Volumes/macinstall/Images/Profile.png" >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#Desktop background
	echo -e "   $yellow ➔ $white Setting desktop background..."
	rm /Library/Desktop\ Pictures/Mojave.heic >/dev/null 2>>/tmp/Brew-Install-Log.txt
	cp /Volumes/macinstall/Images/BF-Background.jpg /Library/Desktop\ Pictures/Mojave.heic >/dev/null 2>>/tmp/Brew-Install-Log.txt
	cp /Volumes/macinstall/Images/BF-Background.jpg /Users/$user/Pictures/BF-Background.jpg >/dev/null 2>>/tmp/Brew-Install-Log.txt
	osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/'$user'/Pictures/BF-Background.jpg"' >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#Require password

	echo -e "   $yellow ➔ $white Setting password on wake..."
	osascript -e 'tell application "System Events" to set require password to wake of security preferences to false' >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#FileVault
	echo -e "   $yellow ➔ $white Enabled FileVault..."
	cp /Volumes/macinstall/FileVault\ Keys/FileVaultMasterModified.keychain /Library/Keychains/FileVaultMaster.keychain >/dev/null 2>>/tmp/Brew-Install-Log.txt
	chown root:wheel /Library/Keychains/FileVaultMaster.keychain >/dev/null 2>>/tmp/Brew-Install-Log.txt
	chmod 644 /Library/Keychains/FileVaultMaster.keychain >/dev/null 2>>/tmp/Brew-Install-Log.txt
	FULLNAME=$(finger $user | grep Name | sed 's/.*Name: //g')

	fdesetup enable -keychain -user $user -password $PASSWORD > /Volumes/macinstall/Recovery\ Keys/"$FULLNAME"\ FileVault\ Recovery\ Key.txt 2>>/tmp/Brew-Install-Log.txt

	#Firewall
	echo -e "   $yellow ➔ $white Enabled firewall..."
	defaults write /Library/Preferences/com.apple.alf globalstate -int 2 >/dev/null 2>>/tmp/Brew-Install-Log.txt
	#Setting up automatic updates
	echo -e "   $yellow ➔ $white Enabled automatic updates..."
	defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE >/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool false>/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true >/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool false >/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE >/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true >/dev/null 2>>/tmp/Brew-Install-Log.txt
	defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#Set top left hot corner
	echo -e "   $yellow ➔ $white Setting top left hot corner..."
	su $USER -c 'defaults write com.apple.dock wvous-tl-corner -int 10' >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#Show battery percent
	echo -e "   $yellow ➔ $white Enabled battery percent..."
	su $USER -c 'defaults write com.apple.menuextra.battery ShowPercent YES' >/dev/null 2>>/tmp/Brew-Install-Log.txt

	#Chrome Extensions
	echo -e "   $yellow ➔ $white Installing Chrome extensions..."
	mkdir /Library/Application\ Support/Google &> /dev/null
	mkdir /Library/Application\ Support/Google/Chrome &> /dev/null
	mkdir /Library/Application\ Support/Google/Chrome/External\ Extensions &> /dev/null
	touch /Library/Application\ Support/Google/Chrome/External\ Extensions/hdokiejnpimakedhajhdlcegeplioahd.json &> /dev/null
	touch /Library/Application\ Support/Google/Chrome/External\ Extensions/cjpalhdlnbpafiamejdnhcphjbkeiagm.json &> /dev/null
	echo {"external_update_url": "https://clients2.google.com/service/update2/crx"} > /Library/Application\ Support/Google/Chrome/External\ Extensions/hdokiejnpimakedhajhdlcegeplioahd.json 2>>/tmp/Brew-Install-Log.txt
	echo {"external_update_url": "https://clients2.google.com/service/update2/crx"} > /Library/Application\ Support/Google/Chrome/External\ Extensions/cjpalhdlnbpafiamejdnhcphjbkeiagm.json 2>>/tmp/Brew-Install-Log.txt

}

confLittleSnitch(){
	#Little Snitch
	if [ $TECHUSER == y ] || [ $TECHUSER == Y ]
	then
		echo -e "   $yellow ➔ $white Configuring Little Snitch..."
  		sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null
  		sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on >/dev/null
  		sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on >/dev/null
  		sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off >/dev/null
  		sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off >/dev/null
	fi
}

refreshSys(){
	echo -e "   $yellow ➔ $white System refresh..."
	for app in "SystemUIServer" "cfprefsd" "Finder" "Dock"; do
	    sudo killall $app
	done
}
main
