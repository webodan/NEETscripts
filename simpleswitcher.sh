#!/bin/bash

function RunHDMIScreen {
gsettings set org.gnome.desktop.interface cursor-size 36 &
gsettings set org.gnome.desktop.interface scaling-factor 1 &
gsettings set org.gnome.desktop.interface text-scaling-factor 1.55 &
xrandr --output DVI-D-0 --off --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --off --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off &
#sleep .5
pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo" &
pacmd list-sink-inputs | grep index | while read line
do
pacmd move-sink-input `echo $line | cut -f2 -d' '` "alsa_output.pci-0000_01_00.1.hdmi-stereo" &
done
#pulseaudio -k &
#SERVICE="chromium"
#RESULT=`pgrep ${SERVICE}`
#if [ "${RESULT:-null}" = null ]; then
#chromium-browser --restore-last-session &
#else
#wmctrl -c chromium && chromium-browser --restore-last-session &
#fi
}

function RunMonitors {
gsettings set org.gnome.desktop.interface text-scaling-factor 1 &
gsettings set org.gnome.desktop.interface scaling-factor 1 & 
gsettings set org.gnome.desktop.interface cursor-size 24 & 
xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-I-1 --off --output DVI-I-0 --mode 1024x768 --pos 1920x7 --rotate normal --output DP-1 --off --output DP-0 --off &
pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo" &
pacmd list-sink-inputs | grep index | while read line
do
pacmd move-sink-input `echo $line | cut -f2 -d' '` "alsa_output.pci-0000_03_07.0.analog-stereo" &
done
#sleep .5
#pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo" &
#killall pulseaudio &
#pulseaudio -k &
#pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo" &
#SERVICE="chromium"
#RESULT=`pgrep ${SERVICE}`
#if [ "${RESULT:-null}" = null ]; then
#chromium-browser --restore-last-session &
#else
#wmctrl -c chromium && chromium-browser --restore-last-session &
#fi
}

function HDMIConnected {
   xrandr | grep "HDMI-0" | grep "primary" # 1) this function finds a 1920x1080 with HDMI-0 as its device identifier, aka my HDMI TV (this only activates when it is plugged in and outputting video at runtime)
}

if HDMIConnected # 2) if the HDMI TV is connected and running, the script assumes that you want to change to the VGA and DVI monitors also installed on the system, so....
then
RunMonitors # 3) that's exactly what it does in this part, then exits.
else
RunHDMIScreen
fi
exit
