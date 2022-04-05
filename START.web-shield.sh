#!/bin/bash
# 
# run as root
# 
# If you want to customize this, create a copy and set that up as your start command
# I personally prefer to not have this automatically run during boot in case anything
# goes wrong - I like to manually start it, but YMMV.
# 
# specify the location of your login shield installation
MYPATH=./
#
#
cd $MYPATH
echo "This script creates and intializes the login-shield blacklist"
echo ""
# create the ipset list
./webshield-create-blacklist.sh
#
# Edit or comment out any lists you don't want added
#
./blacklist-nonUS.sh
./blacklist-other.sh
./blacklist-US.sh
#
./webshield-set-iptables.sh
#
echo "## Done."

