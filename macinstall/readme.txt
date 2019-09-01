Format a flash drive and give it the name macinstall.
Drop this entire project on the root.
Boot up a MacBook into recovery mode.
Disable SIP by typing csrutil disable into a terminal.
Reboot into normal OS.
Get through OOBE.
Load terminal and sudo start the autoConfig.sh script.

If necessary...
chmod +x autoConfig.sh
sudo xattr -r -d com.apple.quarantine autoConfig.sh
