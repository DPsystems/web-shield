# This script is used for when you have web-shield already running and have done a
# git pull and retrived an updated list
# this will flush the existing config and rebuild the system

# remove iptables reference
./webshield-set-iptables.sh del
# clear existing list
ipset flush web-shield
# reload the whole system (NOTE: replace this with whatever startup command you're using if different)
./START.web-shield.sh

