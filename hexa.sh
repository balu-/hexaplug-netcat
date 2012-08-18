#!/bin/bash
PRE="\x48\x45\x58\x41\x42\x55\x53\x01\x00"

if [ "${2}" = "on" ]; then
DO="$PRE\x10"
printf "$DO" | nc6 -6 -u --send-only $1%usb0 61616
elif [ "${2}" = "off" ]; then
DO="$PRE\x11"
printf "$DO" | nc6 -6 -u --send-only $1%usb0 61616
elif [ "${2}" = "status" ]; then
RES=1
DO="$PRE\x12"
printf "$DO" | nc6 -6 -u --send-only $1%usb0 61616
elif [ "${2}" = "value" ]; then
RES=2
DO="$PRE\x13"
printf "$DO" | nc6 -6 -u --send-only $1%usb0 61616
elif [ "${2}" = "set_default" ]; then
DO="$PRE\xde"
printf "$DO" | nc6 -6 -u --send-only $1%usb0 61616
elif [ "${2}" = "set_default_off" ]; then 
echo "sets the default state to off"
echo "POST /config.shtml HTTP/1.1\r\nContent-length: 36\r\n\r\ndomain_name=Socket&relay=0&routing=0\r\n" | nc6 -6 $1%usb0 80
else
echo "Usage: $0 <ipv6> (on|off|status|value|set_default|set_default_off)"
exit
fi;
if [ "$RES" = "1" ]; then
nc6 -w 0 --hold-timeout=0 -t 0 -u -6 -l -p 61616 
elif [ "${RES}" = "2" ]; then
OUTPUT=`nc6 -w 5 --hold-timeout=0 -t 1 -u -6 -l -p 61616 | od -t u1 -j 11 -A n ` #-N 1| head -n 1` 
echo $OUTPUT    
    exit $OUTPUT
fi;

