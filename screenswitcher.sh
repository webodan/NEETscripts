#!/bin/bash
#
# Personal environment switch script. Made in 2017 by webodan.
# Released under the terms of the GNU GPL V2. see the LICENSE file for details.
# It switches, depending on the enabled displays at runtime, from the enabled displays and audio output to the other ones I have on my workbench (HDMI TV and HDMI audio output to twin monitors and PCI sound card, and vice-versa). Also reboots my browser so it outputs sound to the new audio output.
# Easily customizable by replacing the default pulseaudio sink (aka audio output, get yours with pacmd list-sinks) and display device identifiers (find those with xrandr, it's something on the lines of HDMI-0, DFP-1, DVI-D-0... depends on your GPU and displays) listed in this script with your own.
# Happy hacking
#
function RunHDMIScreen {
xrandr --output DVI-I-0 --off --output DVI-D-0 --off --output HDMI-0 --primary --mode 1920x1080 -r 60 --pos 0x0 --rotate normal --dpi 120 &
pulseaudio -k &
sleep .5
pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo"
openbox --restart &
killall conky &
SERVICE="chromium"
RESULT=`pgrep ${SERVICE}`
if [ "${RESULT:-null}" = null ]; then
chromium --restore-last-session &
else
wmctrl -c chromium && chromium --restore-last-session &
fi
}
function RunMonitors {
xrandr --output DVI-D-0 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-I-1 --off --output DVI-I-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output DP-0 --off --dpi 96 &
pulseaudio -k &
sleep .5
pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo"
openbox --restart &
sleep 3
SERVICE="chromium"
RESULT=`pgrep ${SERVICE}`
if [ "${RESULT:-null}" = null ]; then
conky && chromium --restore-last-session &
else
wmctrl -c chromium && chromium --restore-last-session &
conky & # I only use conky when running the monitors
fi
}
function CheckHDMI {
    [ $MONITOR = "HDMI-0" ]
}
function HDMIConnected {
   xrandr | grep "HDMI-0" | grep 1920 # 1) this function finds a 1920x1080 with HDMI-0 as its device identifier, aka my HDMI TV (this only activates when it is plugged in and outputting video at runtime)
}
if HDMIConnected # 2) if the HDMI TV is connected and running, the script assumes that you want to change to the VGA and DVI monitors also installed on the system, so....
then
RunMonitors # 3) that's exactly what it does in this part, then exits.
exit
fi
if ! HDMIConnected #if the HDMI screen is not running video...
then
RunHDMIScreen #disable the monitors and enable it
exit
fi
