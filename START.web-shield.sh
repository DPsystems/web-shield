# Rename this to S.login-shield.sh after customizing
# run as root
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

