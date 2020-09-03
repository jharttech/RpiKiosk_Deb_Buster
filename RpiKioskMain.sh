#! /bin/bash


############################################

# This script will act as a starting page for
# the gui version of RpiKioskHelperScript
# allowing the user to chose which script to run


############################################
# Global Declarations

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

exec 3>&1


############################################

#Install needed package "dialog"

#sudo apt-get update
#sudo apt-get install dialog

# Logo Call
dialog --title "Jharttech" \
	--exit-label "" \
	--timeout 1 \
	--colors \
	--begin 0 0 \
	--textbox /usr/local/bin/logo.txt 0 0 


############################################
# Menu
selection=$(dialog --title "Selection Menu" \
	--clear \
	--menu "Please select what you would like to do." 30 80 5 \
	Install "Start the Rpi Kiosk Installation" \
	Uninstall "Starts the Rpi Kiosk Uninstallation" \
	Disable_Mouse "Starts the Disable Mouse during Kiosk process" \
	Enable_Mouse "Starts the Enable Mouse during Kiosk process" \
	Turn_On_Off_Wifi_Power_Save "Turn the wifi power save on or off" 2>&1 1>&3)
_Respns=$?
if [ "${_Respns}" == "0" ];
then
	case $selection in
		Install)
			/usr/local/bin/RpiKioskInstall.sh ;;
		Uninstall)
			/usr/local/bin/RpiKioskUninstall.sh;;
		Disable_Mouse)
			/usr/local/bin/RpiKioskCursorDisable.sh;;
		Enable_Mouse)
			/usr/local/bin/RpiKioskCursorEnable.sh;;
		Turn_On_Off_Wifi_Power_Save)
			/usr/local/bin/RpiKioskWifiPower.sh;;
	esac
else if [ "${_Respns}" == "1" ];
then
	exit
fi
fi


############################################
