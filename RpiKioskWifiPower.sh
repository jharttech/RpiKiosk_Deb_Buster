#!/bin/bash
set -x
############################################################3
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
        --textbox /usr/local/bin/logo.txt 0 0 \


#####################################################
while true; do
	dialog --title "Adjust Wifi Power Save" \
	--clear \
	--yes-label "Turn On" \
	--no-label "Turn Off" \
	--yesno "How would you like to adjust wifi power saving?" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		iw dev wlan0 get power_save > /tmp/status
		_StateOfWifiPS=$(cat /tmp/status)
		dialog --title "Power Save Status" \
			--clear \
			--sleep 2 \
			--infobox "Checking to see the current state of the wifi power save." 0 0
		if [ "Power save: off" == "$_StateOfWifiPS" ];
		then
			dialog --title "Turn On Wifi Power Save"
			 	--clear \
                        	--sleep 3 \
                        	--infobox "Now going to create the needed startup script to enable wifi power save." 0 0
                        echo -e "#!/bin/sh\n# off-power-manager - Enable the internal power manager of the (built-in) wlan0 device\niw dev wlan0 set power_save on" | sudo tee -a /etc/network/if-up.d/off-power-manager > /dev/null
                        	--sleep 2
                        sudo chmod +x /etc/network/if-up.d/off-power-manager > /dev/null
                        sudo /etc/init.d/networking restart > /dev/null
                        iw dev wlan0 get power_save > /tmp/status
                        dialog --title "Power Save Status" \
                                --clear \
                                --timeout 2 \
                                --exit-label "" \
                                --textbox /tmp/status 15 50
                        rm /tmp/status
			break

		else
			if [ "Power save: on" == "$_StateOfWifiPS" ];
			then
				dialog --title "Power Save Status" \
					--clear \
					--sleep 3 \
					--infobox "Wifi Power Save feature is already enabled. Nothing to do!" 0 0
				break
		fi
	fi
	else
		if [ "${yn}" == "1" ];
		then
			dialog --title "Turn Off Wifi Power Save" \
		 		--clear \
                        	--sleep 3 \
                        	--infobox "Now going to create the needed startup script to disable wifi power save." 0 0
                        echo -e "#!/bin/sh\n# off-power-manager - Disable the internal power manager of the (built-in) wlan0 device\niw dev wlan0 set power_save off" | sudo tee -a /etc/network/if-up.d/off-power-manager > /dev/null
                        	--sleep 2 \
                        sudo chmod +x /etc/network/if-up.d/off-power-manager
                        sudo /etc/init.d/networking restart > /dev/null
                        iw dev wlan0 get power_save > /tmp/status
                        dialog --title "Power Save Status" \
                                --clear \
                                --timeout 2 \
                                --exit-label "" \
                                --textbox /tmp/status 15 50
                        rm /tmp/status
			break

	fi
fi
done
#############################################################
while true; do
        dialog --title "Thank You!" \
                --clear \
                --yes-label "Exit" \
                --no-label "Restart Now" \
                --yesno "All done!! Thank You -Jhart" 0 0
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
