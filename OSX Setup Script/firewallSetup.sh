#!/usr/bin/env bash

"
Tested on 10.14

Last option seems to give back an error?
"

firewallSetup(){
  printf "Setting up firewall + settings \n\n"
  printf "Enabling Firewall"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

  printf "Blocks all incoming connections"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

  printf "Enabling Logging"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

  printf "Enabling Stealth Mode"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  #(Stealth Mode) Prevents computer from responding to ICMP ping requests and does not answer to
  #connection attempts from a closed TCP or UDP port

  #set whether signed applications are to automatically receive incoming connections or not
  printf "Blocking automatic connections from signed apps"
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
}

firewallSetup
