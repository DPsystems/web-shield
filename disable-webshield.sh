#!/bin/bash

# this script will temporarily disable web-shield
# this is useful for being called in procedures where you need to temporarily take down web shield, like for certbot

SET_NAME=empty_set

# create empty set if it doesn't exist

ipset -exist create $SET_NAME hash:net

# Let's check to make sure we're using an empty set

ENTRIES=$(sudo ipset list "$SET_NAME" -terse | grep "Number of entries:" | awk '{print $4}')

if [ "$ENTRIES" -eq 0 ]; then

        echo "## Temporarily disabling web-shield"
        ipset swap web-shield $SET_NAME

else
    echo "The set '$SET_NAME' is NOT empty. It contains $ENTRIES items.  Aborting."
fi

