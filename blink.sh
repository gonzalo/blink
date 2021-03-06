#!/bin/sh
# blink.sh -- version 27-Jun-2016
#
# Copyright 2016 Steven Ford http://geeky-boy.com and licensed
# "public domain" style under
# [CC0](http://creativecommons.org/publicdomain/zero/1.0/): 
# 
# To the extent possible under law, the contributors to this project have
# waived all copyright and related or neighboring rights to this work.
# In other words, you can use this code for any purpose without any
# restrictions.  This work is published from: United States.  The project home
# is https://github.com/fordsfords/blink/tree/gh-pages


# Turn on LED with "set_led 1".  Turn it off with "set_led 0".
set_led()
{
  if [ "$1" = "1" ]; then :
    /usr/sbin/i2cset -f -y 0 0x34 0x93 0x1
  elif [ "$1" = "0" ]; then :
    /usr/sbin/i2cset -f -y 0 0x34 0x93 0x0
  else :
    echo "Usage: set_led 1|0" >&2
    exit 1
  fi
}

button_not_pressed()
{
  REG34H=`i2cget -f -y 0 0x34 0x4a`  # Read AXP209 register 34H
  BUTTON=$((REG34H & 0x02))  # mask off the short press bit
  if [ $BUTTON -eq 0 ]; then :
    return 0  # Button not pressed, return 0 for success.
  elif [ $BUTTON -eq 2 ]; then :
    return 1  # Button is pressed, return 1 for fail.
  else :
    echo "button_not_pressed is confused: REG34H='$REG34H', BUTTON='$BUTTON'" >&2
    exit 1
  fi
}

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Write PID of running script to /tmp/blink.pid
echo $$ >/tmp/blink.pid

LED=0
# Loop until detects short press of reset button
while button_not_pressed; do :
  sleep 1
  set_led $LED
  LED=`expr 1 - $LED`
done

# Short press detected, shut down.
shutdown now
