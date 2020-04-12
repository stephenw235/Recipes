#!/bin/bash

echo "Writing app install path to preference file..."
defaults write us.zoom.ringcentral installPath "/Applications/RingCentral Meetings.app"

echo "Removing RingCentral Meetings plugin from existing user folders..."
REL_PATH="Library/Internet Plug-Ins/RingCentralMeetings.plugin"
# Using dscl instead of ls because we can't assume home folders are in /Users.
for THIS_USER in $(/usr/bin/dscl . -list /Users UniqueID | awk '$2 > 500 {print $1}'); do
    # Get actual path to home folder of this user.
    USER_HOME=$(/usr/bin/dscl . -read "/Users/$THIS_USER" NFSHomeDirectory | awk '{print $2}')
    if [[ -d "$USER_HOME/$REL_PATH" ]]; then
        echo "$USER_HOME/$REL_PATH"
        # Because this path will never expand to /, we can ignore rule 2115:
        # shellcheck disable=SC2115
        rm -rf "$USER_HOME/$REL_PATH"
    fi
done

exit 0
