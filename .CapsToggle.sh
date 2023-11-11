#!/bin/bash
# Get the current options
CURRENT_OPTIONS=$(setxkbmap -query | grep "options:" | cut -d':' -f2- )
parameters="${CURRENT_OPTIONS##*( )}"  # Trim leading whitespace

echo "$CURRENT_OPTIONS"

swp1="caps:ctrl_modifier"
swp2="caps:capslock"

if echo "$CURRENT_OPTIONS" | grep -q "$swp1"; then
    NEW_OPTIONS=$(echo "$CURRENT_OPTIONS" | sed -E "s/\s*(.*)$swp1(,|\$)(.*)/$swp2,\1\3/")
    notify-send "NOW ACTIVE $swp2"
else
    #TREBA VYPNUT CL
    sleep 0.2
    xdotool keyup Caps_Lock key Caps_Lock
    ORIGIN=$(echo "$CURRENT_OPTIONS" | sed -E "s/\s*(.*)$swp2(,|\$)(.*)/\1\3/") #removes $swp2 from list
    NEW_OPTIONS="${swp1},${ORIGIN}" #prepends swp1 to default list
    notify-send "NOW ACTIVE $swp1"
fi
echo "$NEW_OPTIONS"

# Apply the new options
setxkbmap -option -option "$NEW_OPTIONS"

