#!/bin/bash
# monitor and audio output switch script using variables
# new version includes checking for connected bluetooth headphones and skips audio switching if connected

hdmicard=$(pacmd list-sinks | awk '/name:/ {print $0};' | awk '{ print $2}' | sed 's/<//g; s/>//g' | grep hdmi)
analogcard=$(pacmd list-sinks | awk '/name:/ {print $0};' | awk '{ print $2}' | sed 's/<//g; s/>//g' | grep analog)
bluetoothcard=$(pacmd list-sinks | awk '/name:/ {print $0};' | awk '{ print $2}' | sed 's/<//g; s/>//g' | grep blue)

dvimonitor=$(xrandr | grep -E " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | grep DP)
hdmitv=$(xrandr | grep -E " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | grep HDMI)


function HDMITV {
                xrandr --output $dvimonitor --off --output $hdmitv --mode 1920x1080 -r 60.00 &
		sleep 1s;       
	if pactl list short cards | grep blue;
        then
                pactl set-card-profile 2 off
                pactl set-card-profile 0 output:hdmi-stereo-extra1
                pactl set-default-sink $bluetoothcard
        exit
        else	
		pactl set-card-profile 2 off
		pactl set-card-profile 0 output:hdmi-stereo-extra1
                pacmd set-default-sink $hdmicard
		pacmd set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1
	fi
}
function DPMonitor {
                xrandr --output $dvimonitor --mode 1920x1080 -r 74.92 --output $hdmitv --off &
	if pactl list short cards | grep blue;
        then
                pactl set-card-profile 0 off
                pactl set-card-profile 2 output:analog-stereo
                pactl set-default-sink $bluetoothcard
        exit
        else
		pactl set-card-profile 0 off
		pactl set-card-profile 2 output:analog-stereo
                pacmd set-default-sink $analogcard
                pactl -- set-sink-volume $analogcard 100%
	fi
}

function HDMIConnected {
   xrandr | grep HDMI | grep 1920
}

function DPConnected {
   xrandr | grep DP | grep 1920
}


if ! HDMIConnected
	then
	HDMITV
	else
	DPMonitor
fi
