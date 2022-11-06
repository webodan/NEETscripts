#!/bin/bash
# monitor switch script with variables
# new version includes checking for connected bluetooth headphones and skips audio switching if connected
# thanks jon almeida blog post

hdmicard=$(pacmd list-sinks | awk '/name:/ {print $0};' | awk '{ print $2}' | sed 's/<//g; s/>//g' | grep hdmi-stereo-extra)
analogcard=$(pacmd list-sinks | awk '/name:/ {print $0};' | awk '{ print $2}' | sed 's/<//g; s/>//g' | grep analog)

dvimonitor=$(xrandr | grep -E " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | grep DP)
hdmitv=$(xrandr | grep -E " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/" | grep HDMI)

while [ ! $# -eq 0 ]
do

	case "$1" in
	--hdtv)
		# HDMI TV only
		xrandr --output $dvimonitor --off --output $hdmitv --primary --mode 1920x1080 -r 60 --pos 0x0 --rotate normal &
		pacmd set-default-sink $hdmicard
#		xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 69
#		xfconf-query -c xfwm4 -p /general/theme -s RedmondXP-hidpi
#		xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 48
#		xfconf-query -c xsettings -p /Xft/DPI -s 190
		pactl -- set-sink-volume $hdmicard 100%
		pacmd set-default-sink $hdmicard
		exit
			;;
		--hdmon)

		# HD Monitor only
		xrandr --output $dvimonitor --mode 1920x1080 -r 85 --rotate normal --output $hdmitv --off &
		pacmd set-default-sink $analogcard
#		xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 59
#		xfconf-query -c xfwm4 -p /general/theme -s RedmondXP
#		xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 24
#		xfconf-query -c xsettings -p /Xft/DPI -s 100
		pactl -- set-sink-volume $analogcard 100%
		exit
			;;
	esac
done

function HDMITV {
                xrandr --output $dvimonitor --off --output $hdmitv --mode 1920x1080 -r 60.00 &
		sleep 1s;
		pactl set-card-profile 2 off
		pactl set-card-profile 0 output:hdmi-stereo-extra1
                pacmd set-default-sink $hdmicard
		pacmd set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo
		pacmd set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1
#               xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 69
#               xfconf-query -c xfwm4 -p /general/theme -s RedmondXP-hidpi
#               xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 48
#               xfconf-query -c xsettings -p /Xft/DPI -s 190
#               pactl -- set-sink-volume $hdmicard 100%
#                pacmd set-default-sink $hdmicard
}
function DPMonitor {
                xrandr --output $dvimonitor --mode 1920x1080 -r 74.92 --output $hdmitv --off &
		pactl set-card-profile 0 off
		pactl set-card-profile 2 output:analog-stereo
                pacmd set-default-sink $analogcard
#               xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 59
#               xfconf-query -c xfwm4 -p /general/theme -s RedmondXP
#               xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 24
#               xfconf-query -c xsettings -p /Xft/DPI -s 100
                pactl -- set-sink-volume $analogcard 100%
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
