# webshield-create-blacklist.sh
#
# creates ipset table
#
SET_NAME="web-shield"

# hash:ip individual, hash:net = netblocks
SET_TYPE="hash:net"
SET_CONFIG="hashsize 16384 maxelem 131072"

#ipset create $SET_NAME $SET_TYPE $SET_CONFIG

ipset -exist create $SET_NAME hash:net

