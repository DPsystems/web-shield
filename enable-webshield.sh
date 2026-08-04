#!/bin/bash

# this script will enable a previously temporarily disabled web-shield
# this is useful for being called in procedures where you need to temporarily take down web shield, like for certbot

EMPTY_NAME=empty_set

# create empty set if it doesn't exist
# don't create because it should already exist
#ipset -exist create $EMPTY_NAME hash:net

# Let's check to make sure we're using an empty set

ENTRIES=$(sudo ipset list "$EMPTY_NAME" -terse | grep "Number of entries:" | awk '{print $4}')

if [ "$ENTRIES" -eq 0 ]; then

    echo "The web-shield replacement set '$EMPTY_NAME' is empty."
    WENTRIES=$(sudo ipset list "web-shield" -terse | grep "Number of entries:" | awk '{print $4}')
    echo "The current web-shield list contains $WENTRIES entries.   Aborting."

else

        echo "## Enabling web-shield"
        ipset swap web-shield $EMPTY_NAME
fi

