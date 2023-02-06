#!/bin/sh
#using python script autorandr
#install using pip install autorandr, and create profiles once every monitor is set up using autorandr --save <profile> so it works

function checkTV {
autorandr | grep current | grep TV
}

function hdmi { 
autorandr --load TV
pactl set-card-profile 47 off
pactl set-card-profile 46 output:hdmi-stereo
sleep 2s;
#wpctl set-default $(wpctl status | grep "(HDMI)" | cut -b10-12)
#killall conky; conky -c "/home/dan/.conky/duchys/conky.conf"
}

function monitor {
autorandr --load monitor;
pactl set-card-profile 46 off	
pactl set-card-profile 47 output:analog-stereo
#wpctl set-default $(wpctl status | grep "Estéreo analógico" | cut -z -c 11-12)
#killall conky; conky -c "/home/dan/.conky/duchys/conky-monitor.conf"
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
