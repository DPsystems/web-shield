#!/bin/bash
#
# Script to analyze Web-shield blocked attack attemps and generate
# statistics identifying the most aggressive sources of attacks
#
# Note that this script, unlike Login Shield, cannot tell you what percentage
# of attacks were blocked/allowed - we assume anything we don't block is regular web traffic
#
# OPTIONAL: add parameter "lookup" to display country associated with top attacks
#
# V 1.0.0 - removed temp files, created in /tmp/ dir

# filespec of logfile containing invalid login attempts
BL_LOGFILE=/var/log/messages
BL_GREP="WbSH:"
# temp directory for work files
TDIR="/tmp/"


# accepts one commane line parameter: # 1 top IPs to list (default 40)
if [ -z $2 ]; then
	COUNT=40
else
	NUMREGEX='^[0-9]+$'
	if [[ $2 =~ $NUMREGEX ]] ; then
	  COUNT="$2"
	else
	 COUNT=40
	fi
fi


echo '|\     /|(  ____ \(  ___ \      (  ____ \|\     /|\__   __/(  ____ \( \      (  __  \ '
echo '| )   ( || (    \/| (   ) )     | (    \/| )   ( |   ) (   | (    \/| (      | (  \  )'
echo '| | _ | || (__    | (__/ /_____ | (_____ | (___) |   | |   | (__    | |      | |   ) |'
echo '| |( )| ||  __)   |  __ ((_____)(_____  )|  ___  |   | |   |  __)   | |      | |   | |'
echo '| || || || (      | (  \ \            ) || (   ) |   | |   | (      | |      | |   ) |'
echo '| () () || (____/\| )___) )     /\____) || )   ( |___) (___| (____/\| (____/\| (__/  )'
echo '(_______)(_______/|/ \___/      \_______)|/     \|\_______/(_______/(_______/(______/ '
                                                                                      

echo '======= Attack Statistics based on current log files ======='
echo " Using: $BL_LOGFILE"
echo
START=`head -n 1 $BL_LOGFILE | tr -s ' ' | cut -d ' ' -f 1-3`
echo "From: $START"
END=`tail -n 1 $BL_LOGFILE | tr -s ' ' | cut -d ' ' -f 1-3`
echo "To  : $END"
echo

cat $BL_LOGFILE  | grep -i "$BL_GREP" | tr -s ' ' > $TDIR"temp.txt"
FAILS=`cat $TDIR"temp.txt" | wc -l`

echo "-- Number of blocked attacks in log files  : $FAILS"

# version without ports
cat $TDIR"temp.txt"  | cut -d ' ' -f 9 | sed -e 's/SRC=//g' | sed -e 's/DPT=//g' | sed -e 's/ /:/g' > $TDIR"temp2b.txt"
sort $TDIR"temp2b.txt" | uniq -c > $TDIR"temp3b.txt"
sort -r -n $TDIR"temp3b.txt" > $TDIR"ip_rankings.txt"

UNIQUE_IPS=`cat $TDIR"ip_rankings.txt" | wc -l`
ATKPERIP=`awk "BEGIN { printf \"%d\", $FAILS / $UNIQUE_IPS }"`

TOP5=`head -n 5 $TDIR"ip_rankings.txt" | awk '{s+=$1} END {printf "%.0f", s}'`
TOP5PCT=`awk "BEGIN { printf \"%.1f\", $TOP5 / $FAILS * 100 }"`

TOP10=`head -n 10 $TDIR"ip_rankings.txt" | awk '{s+=$1} END {printf "%.0f", s}'`
TOP10PCT=`awk "BEGIN { printf \"%.1f\", $TOP10 / $FAILS * 100 }"`

TOP50=`head -n 50 $TDIR"ip_rankings.txt" | awk '{s+=$1} END {printf "%.0f", s}'`
TOP50PCT=`awk "BEGIN { printf \"%.1f\", $TOP50 / $FAILS * 100 }"`

echo "-- Number of unique IP addresses attacking : $UNIQUE_IPS"
echo "   Average # of attacks per IP             : $ATKPERIP"
echo "   Percentage of attacks from top 50 IPs   : $TOP50PCT%"
echo "   Percentage of attacks from top 10 IPs   : $TOP10PCT%"
echo "   Percentage of attacks from top 5 IPs    : $TOP5PCT%"
echo

echo "      Top $COUNT:"

if [ "$1" == "lookup" ]; then

echo "Attacks:  IP Address:  Country:"
echo "-------------------------------"
IFS=''
head -n $COUNT $TDIR"ip_rankings.txt" | while read line
do
        echo -n $line
        IP=`echo $line | tr -s ' ' | cut -d ' ' -f 3`
        COUNTRY_LINE=`whois $IP | tac | grep -i -m 1 'country:'`
        COUNTRY=`echo $COUNTRY_LINE | tr -s ' ' | cut -d ' ' -f 2`
        echo -e -n '\t'
        echo "$COUNTRY"

done

else
	echo "Attacks:  IP Address:"
	echo "---------------------"
	head -n $COUNT $TDIR"ip_rankings.txt"
fi
# remove temp files
rm -f $TDIR"temp.txt"
rm -f $TDIR"temp2b.txt"
rm -f $TDIR"temp3b.txt"
rm -f $TDIR"ip_rankings.txt"
# done

