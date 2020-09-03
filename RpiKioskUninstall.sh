#!/bin/bash

###########################################

# Simple Script to undo all changes made to pi to
# Create pi Kiosk

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

# Logo Call

dialog --title "Jharttech" \
	--clear \
	--timeout 1 \
	--exit-label "" \
	--textbox /usr/local/bin/logo.txt 0 0

#############################################


while true; do
	dialog --title "Uninstall Kiosk" \
		--clear \
		--yesno "This script will remove the configuration changes made by running the KioskInstall script.\n\nThis will return your pi back to its natural state after a reboot.  Are you sure you want to continue?" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		_Boot_Config=$(ls /boot/ | grep "config.txt.DSbackup")
		dialog --title "Config Check" \
			--clear \
			--sleep 3 \
			--infobox "Looking to see if /boot/config file has been changed.\n\nIf so reverting it back to original." 0 0
		if [ "" == "$_Boot_Config" ];
		then
			dialog --title "Revert Configs" \
				--clear \
				--sleep 3 \
				--infobox "Nothing to be changed in /boot/config.txt" 0 0
		else
			dialog --title "Revert Configs" \
				--clear \
				--sleep 3 \
				--infobox "Changing /boot/config.txt back to original state." 0 0
			sudo rm -rf /boot/config.txt
			sudo mv /boot/config.txt.original /boot/config.txt
		fi
		_Autostart_Check=$(ls /etc/xdg/lxsession/LXDE-pi/ | grep "autostart.DSbackup")
		dialog --title "Revert Autostart Config" \
			--clear \
			--cleep 3 \
			--infobox "Looking to see if autostart has been changed.\n\nIf so reverting it back to original." 0 0
		if [ "" == "$_Autostart_Check" ];
		then
			dialog --title "Autostart Check" \
				--clear \
				--sleep 3 \
				--infobox "Nothing to be changed in autostart config."
		else
			dialog --title "Autostart Revert" \
				--clear \
				--sleep 3 \
				--infobox "Changing autostart config back to the original state." 0 0
			sudo rm -rf /etc/xdg/lxsession/LXDE-pi/autostart
			sudo mv /etc/xdg/lxsession/LXDE-pi/autostart.original /etc/xdg/lxsession/LXDE-pi/autostart
		fi
		_Kiosk_Ran=$(ls /etc/lightdm/ | grep "lightdm.conf.DSbackup")
		dialog --title "Mouse Status" \
			--clear \
			--sleep 3 \
			--infobox "Checking to see if mouse cursor has been disabled." 0 0
		if [ "" == "$_Kiosk_Ran" ];
		then
			dialog --title "Mouse Disabled Check" \
				--clear \
				--sleep 3 \
				--infobox "No configuration changes need to be made." 0 0
		else
			dialog --title "Mouse Disabled Revert" \
				--clear \
				--sleep 4 \
				--infobox "Reverting the /etc/lightdm/lightdm.conf file back to original.\n\nThis will allow your mouse cursor to return after rebooting your pi." 0 0
			sudo rm -rf /etc/lightdm/lightdm.conf
			sudo mv /etc/lightdm/lightdm.conf.original /etc/lightdm/lightdm.conf
			fi
			break
	else
		if [ "${yn}" == "1" ];
		then
			dialog --title "Cancel Uninstall" \
				--clear \
				--sleep 3 \
				--infobox "No changes will be made." 0 0
		break
		fi
	fi
done

########################################################################
while true; do
	dialog --title "Thank You!" \
		--clear \
		--yes-label "Exit" \
		--no-label "Restart Now" \
		--yesno "All done!!\n\nPlease reboot your pi for changes to take effect\n\nThank you -JHart" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		sudo rm -r /usr/local/bin/License
		sudo rm -r /usr/local/bin/logo.txt
		sudo rm -f /usr/local/bin/Rpi*
		exit
	else if [ "${yn}" == "1" ];
	then
		sudo rm -f /usr/local/bin/Rpi*
		sudo reboot
	fi
fi
done

