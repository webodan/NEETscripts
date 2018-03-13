#!/bin/bash

function RunHDMIScreen {
# change DPI to acommodate HDMI TV
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
}

function RunMonitors {
# restore DPI to default values for multimonitor desktop setup
gsettings set org.gnome.desktop.interface text-scaling-factor 1 &
gsettings set org.gnome.desktop.interface scaling-factor 1 & 
gsettings set org.gnome.desktop.interface cursor-size 24 & 
xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-I-1 --off --output DVI-I-0 --mode 1024x768 --pos 1920x7 --rotate normal --output DP-1 --off --output DP-0 --off &
pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo" &
pacmd list-sink-inputs | grep index | while read line
do
pacmd move-sink-input `echo $line | cut -f2 -d' '` "alsa_output.pci-0000_03_07.0.analog-stereo" &
done
}

function HDMIConnected {
   xrandr | grep "HDMI-0" | grep "primary" # checks whether HDMI TV is running as primary (PC in HDTV Mode)
}

if HDMIConnected # if such is the case...
then
RunMonitors # the script switches video and audio output and changes DPI settings to acommodate desktop monitor use
else
RunHDMIScreen # if the script was ran having the desktop monitors running, it changes back to HDTV
fi
exit
