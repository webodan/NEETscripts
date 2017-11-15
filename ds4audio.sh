#!/bin/bash
#
# Automatic audio output switching script.
# Made in 2017 by webodan. Released under the terms of the GNU GPL V2. See the LICENSE file for details.
# By default it switches back and forth between my HDMI TV audio output and the DS4's audio output.
# Replace the quoted pulseaudio sink device ID with whatever devices you would prefer using.
# (get your sink devices IDs with the pacmd list-sinks command).


SERVICE="054c:09cc" # Check for the usb device ID of the DS4 V2
RESULT=`lsusb | grep ${SERVICE}`
if [ "${RESULT:-null}" = null ]; then    # if it isn't found, enable the default audio output (HDMI TV in my case). if it is found, switch to the DS4's headphone jack
killall chromium
pulseaudio -k
sleep 1s #give it a slight 1sec delay so that pulseaudio can restart properly
pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo"
chromium --restore-last-session &
else
killall chromium
pulseaudio -k
sleep 1s
pacmd set-default-sink "alsa_output.usb-Sony_Interactive_Entertainment_Wireless_Controller-00.analog-stereo"
chromium --restore-last-session &
exit 0
fi
