#!/bin/bash

##################################################

# Simple script to disable mouse cursor if it has been
# re-enabled using the EnableCursor script

##################################################
# Global Declarations

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

exec 3>&1


##################################################
# Logo Call

dialog --clear \
	--timeout 1 \
	--title "Jharttech" \
	--exit-label "" \
	--textbox /usr/local/bin/logo.txt 0 0

##################################################

_Cursor_Enabled=$(ls /etc/lightdm/ | grep "lightdm.conf.DSbackup")
dialog --title "Mouse Status Check" \
	--clear \
	--sleep 3 \
	--infobox "Checking to see if mouse cursor is already disabled" 0 0
if [ "" == "$_Cursor_Enabled" ];
then
	dialog --title "Backup Config" \
		--clear \
		--sleep 3 \
		--infobox "Now backing up the lightdm.conf file and then editing the file to disable the mouse cursor." 0 0
	sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.DSbackup
	sudo sed -i 's/#xserver-command=X/xserver-command=X -nocursor/' /etc/lightdm/lightdm.conf
	dialog --title "Mouse Status" \
		--clear \
		--sleep 3 \
		--infobox "Mouse cursor has been disabled.  Please reboot your pi for changes to take effect." 0 0
else
	dialog --title "Mouse Status" \
		--clear \
		--sleep 3 \
		--infobox "Nothing to be done.  Your mouse cursor has already been disabled." 0 0
fi

##################################################
while true; do
	dialog --title "Thank You!" \
		--clear \
		--yes-label "Exit" \
		--no-label "Restart Now" \
		--yesno "All done!! Thank You -Jhart" 0 0
	yn=$?
	if [ "${yn}" == "0"];
	then
		/usr/local/bin/RpiKioskMain.sh
		exit
	else if [ "${yn}" == "1" ];
	then
		sudo reboot
	fi
fi
done
