#!/bin/bash

SINK_ID=$(pactl list sink-inputs | sed -n 's/^Sink Input #\([0-9]*\)$/\1/p')

function RunHDMIScreen {
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.55
xrandr --output DVI-D-0 --off --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --off --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo"
pactl move-sink-input $SINK_ID "alsa_output.pci-0000_01_00.1.hdmi-stereo"
}

function RunMonitors {
gsettings set org.gnome.desktop.interface text-scaling-factor 1
xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 0x2 --rotate normal --output HDMI-0 --off --output DVI-I-1 --off --output DVI-I-0 --mode 1024x768 --pos 1920x0 --rotate normal --output DP-1 --off --output DP-0 --off
pacmd set-default-sink "alsa_output.pci-0000_03_07.0.analog-stereo"
pactl move-sink-input $SINK_ID "alsa_output.pci-0000_03_07.0.analog-stereo"
}

function HDMIConnected {
   xrandr | grep "HDMI-0" | grep "primary"
}

if HDMIConnected
then
RunMonitors
else
RunHDMIScreen
fi
exit
