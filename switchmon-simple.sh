#!/bin/sh
#using python script autorandr
#install using pip install autorandr, and create profiles once every monitor is set up using autorandr --save <profile> so it works

function checkTV {
autorandr | grep current | grep TV
}

function hdmi { 
autorandr --load TV
if ! pactl list | grep "Card #" | grep 45
then
pactl set-card-profile 47 off
pactl set-card-profile 46 output:hdmi-stereo
else
pactl set-card-profile 46 off
pactl set-card-profile 45 output:hdmi-stereo
fi
}

function monitor {
autorandr --load monitor;
if ! pactl list | grep "Card #" | grep 45
then
pactl set-card-profile 46 off	
pactl set-card-profile 47 output:analog-stereo
else
pactl set-card-profile 45 off
pactl set-card-profile 46 output:hdmi-stereo
fi
}

if checkTV;
then
monitor
else
hdmi
fi

if pactl list short cards | grep blue;
	then
	wpctl set-default $(wpctl status | grep WH-1000XM4 | cut -z -c 70-71)
       	pactl set-default-sink bluez_output.F8_4E_17_96_DC_11.1
fi

if pgrep xfwm4;
then
xfce4-panel -r
else
exit
fi
