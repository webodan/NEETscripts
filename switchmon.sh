#/bin/bash
# monitor switch script with variables
# wrapped up with pygtk program
# thanks jon almeida blog post

while [ ! $# -eq 0 ]
do

	case "$1" in
	--hdtv)
		# HDMI TV only
		xrandr --output DVI-I-0 --off --output DVI-D-0 --off --output VGA-1-1 --off --output HDMI-0 --primary --mode 1920x1080 -r 60 --pos 0x0 --rotate normal --dpi 120 &
		pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1"
		xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 69
		xfconf-query -c xfwm4 -p /general/theme -s RedmondXP-hidpi
		xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 48
		xfconf-query -c xsettings -p /Xft/DPI -s 190
		pactl -- set-sink-volume alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1 100%
		pacmd set-default-sink "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1"
		pulseaudio -k
		exit
			;;
		--hdmon)

		# HD Monitor only
		xrandr --output DVI-D-0 --mode 1920x1080 --rotate normal --output HDMI-0 --off --output VGA-1-1 --off --dpi 96 &
		pacmd set-default-sink "alsa_output.pci-0000_00_14.2.analog-stereo"
		xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 59
		xfconf-query -c xfwm4 -p /general/theme -s RedmondXP
		xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 24
		xfconf-query -c xsettings -p /Xft/DPI -s 100
		pactl -- set-sink-volume alsa_output.pci-0000_00_14.2.analog-stereo 100%
		pulseaudio -k
		exit
			;;
		--crtmon)
		# CRT Monitor only
		killall steam
		xrandr --output VGA-1-1 --mode 640x480 --rate 60 --output HDMI-0 --off --output DVI-D-0 --off
		xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 39
		xfconf-query -c xfwm4 -p /general/theme -s RedmondXP
		xfconf-query --channel xsettings --property /Gtk/CursorThemeSize --set 16
		xfconf-query -c xsettings -p /Xft/DPI -s 100
		export GDK_SCALE=
		xrandr --output VGA-1-1 --mode 640x480 --rate 85 --output HDMI-0 --off
		steam-native -silent
		exit
			;;
	esac
done
