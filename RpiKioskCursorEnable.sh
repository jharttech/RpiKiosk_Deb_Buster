#!/bin/bash
set -x
####################################################

# This is a simple script to re-enable the mouse cursor
# if is has been disabled when creating kiosk.


####################################################
#Global Declarations

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

exec 3>&1


####################################################
# Logo Call

dialog --title "Jharttech" \
	--clear \
	--timeout 1 \
	--exit-label "" \
	--textbox /usr/local/bin/logo.txt 0 0


#####################################################
_Kiosk_Ran=$(ls /etc/lightdm/ | grep "lightdm.conf.DSbackup")
dialog --title "Script Check" \
	--clear \
	--sleep 3 \
	--infobox "Checking to see if the KioskInstall script has been previously ran." 0 0
if [ "" == "$_Kiosk_Ran" ];
then
	dialog --title "Mouse Status" \
		--clear \
		--sleep 3 \
		--infobox "Mouse was never disabled during Kiosk install.\nNo configuration changes need to be made." 0 0
else
	dialog --title "Mouse Status" \
		--clear \
		--sleep 3 \
		--infobox "Reverting the /etc/lightdm/lightdm.conf file back to original state. This will allow your mouse cursor to return after rebooting your pi." 0 0
	sudo rm -rf /etc/lightdm/lightdm.conf
	sudo mv /etc/lightdm/lightdm.conf.DSbackup /etc/lightdm/lightdm.conf
fi

####################################################
while true; do
	dialog --title "Thank You!" \
		--clear \
		--yes-label "Exit" \
		--no-label "Restart Now" \
		--yesno "All done! Thank you -Jhart" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		/usr/local/bin/RpiKioskMain.sh
		exit
	else if [ "${yn}" == "1" ];
	then
		sudo reboot
	fi
fi
done
