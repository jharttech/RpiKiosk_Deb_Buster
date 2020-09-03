#!/bin/bash

#######################################################

# This script will help do the heavy lifting when trying
# to create a simple Kiosk on a Rpi 3.


#######################################################
# Global Declarations

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

exec 3>&1


#######################################################

# Logo Call
dialog  --title "Jharttech" \
	--clear \
	--timeout 1 \
	--exit-label "" \
	--textbox /usr/local/bin/logo.txt 0 0

######################################################

sudo apt-get update|dialog  --title "Updating Sources" \
	--clear \
	--progressbox 100 100


dialog --title "Tool Check" \
	--msgbox "Going to check for needed tools.\n\nIf they are not found they will be installed." 0 0
_PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unclutter|grep "install ok installed")
if [ "" == "$_PKG_OK" ]; then
	dialog --title "unclutter check" \
		--msgbox "No unclutter tool found.\n\nInstalling and Setting up unclutter now." 0 0
	sudo apt-get -y install unclutter|dialog --title "Installing unclutter" \
		--clear \
		--progressbox 100 100
fi

_PKG_OKTwo=$(dpkg-query -W --showformat='${Status}\n' vim|grep "install ok installed")
if [ "" == "$_PKG_OKTwo" ]; then
	--and-widget --begin --title "vim check" \
		--msgbox "No vim editor found.\n\nInstalling and Setting up vim now." 0 0
	sudo apt-get -y install vim|dialog --title "Installing vim" \
		--clear \
		--progressbox 100 100
fi


#######################################################

# Now going to ask the user for input about the desired screen rotation
# and write it to the appropriate config file.

#######################################################

while true; do
	_Prev_Ran=$(ls /boot/ | grep "config.txt.DSbackup")
	if [ "" == "$_Prev_Ran" ];
	then
		# Make a Backup of original config file
		sudo cp /boot/config.txt /boot/config.txt.original
		dialog --title "Screen Orientation" \
		--clear \
		--yes-label "Landscape" \
		--no-label "Portrait" \
		--yesno "Please specify what screen orientation you will be using." 0 0
		_Rotate=$?
		if [ "$_Rotate" == "0" ];
		then
			dialog --title "Screen Orientation" \
			--sleep 3 \
			--infobox "Now writing the following entries to config file.\n\n# Display orientation. Landscape = 0, Portrait = 1\ndisplay_rotate=0\n" 0 0
			sudo cp /boot/config.txt /boot/config.txt.DSbackup
			echo -e "# Display orientation. Landscape = 0, Portrait = 1\ndisplay_rotate=0" | sudo tee -a /boot/config.txt >/dev/null
			break
		else
			if [ "$_Rotate" == "1" ];
			then
				dialog --title "Screen Orientation" \
				--sleep 3 \
				--infobox "Now writing the following entries to config file.\n\n# Display orientation. Landscape = 0, Portrait = 1\ndisplay_rotate=1\n" 0 0
				sudo cp /boot/config.txt /boot/config.txt.DSbackup
				echo -e "# Display orientation.  Landscape = 0, Portrait = 1\ndisplay_rotate=1" | sudo tee -a /boot/config.txt >/dev/null
				break
			fi
		fi
	else
		sudo mv /boot/config.txt.DSbackup /boot/config.txt
	fi
done


#######################################################

while true; do
	_Prev_RanTwo=$(ls /etc/xdg/lxsession/LXDE-pi/ | grep "autostart.DSbackup")
	if [ "" == "$_Prev_RanTwo" ];
	then
		# Make a copy of original config file
		sudo cp /etc/xdg/lxsession/LXDE-pi/autostart /etc/xdg/lxsession/LXDE-pi/autostart.original
		_URL=$(dialog --title "Signage URL" \
		--clear \
		--inputbox "Please enter the URL of the kiosk video, or slideshow that you wish to show below:" 16 52 2>&1 1>&3)
		_InputRes=$?
		case $_InputRes in
			0)
			dialog --title "Your URL" \
			--clear \
			--yesno "You entered $_URL.\nIs this correct?" 0 0
			yn=$?
			if [ "${yn}" == "0" ];
				then
					dialog --title "Writing to Config" \
					--clear \
					--sleep 3 \
					--infobox "Now writing chromium and kiosk configurations to config file.\nThere will be a backup of original config file created.\nIt will be located /etc/xdg/lxsession/LXDE-pi/autostart.DSbackup." 0 0
					sudo mv /etc/xdg/lxsession/LXDE-pi/autostart /etc/xdg/lxsession/LXDE-pi/autostart.DSbackup
					dialog --title "Autostart Configs" \
					--clear \
					--sleep 3 \
					--infobox "Now writing to following entries to the autostart configuration file.\n\n@xset s off\n@xset -dpms\n@xset s noblank\n@chromium-browser --noerrdialogs --disable-infobars --disable-session-crashed-bubble --incognito --kiosk $_URL" 0 0
					echo -e "@lxpanel --profile LXDE-pi\n@pcmanfm --desktop --profile LXDE-pi\n@xscreensaver -no-splash\npoint-rpi\n@xset s off\n@xset -dpms\n@xset s noblank" | sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart >/dev/null
					echo -e "@chromium-browser --noerrdialogs --disable-infobars --disable-session-crashed-bubble --incognito --kiosk $_URL" | sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart >/dev/null
					break
			fi;;
			1)
			./RpiKioskMain.sh;;
		esac
	else
		sudo mv /etc/xdg/lxsession/LXDE-pi/autostart.DSbackup /etc/xdg/lxsession/LXDE-pi/autostart
	fi
done
##########################################################

# Here we edit the chromium defualt preferences file so that there will be no crash flag upon reboot

sudo sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sudo sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences
##########################################################
##########################################################

##########################################################

# Here we edit the /etc/lightdm/lightdm.conf file to completely remove the mouse cursor from the system.
while true; do
	dialog --title "Should I Stay or Go" \
	--clear \
	--yesno "The mouse cursor has been hidden until moved in your kiosk.\n\nWould you like to remove the mouse cursor permenantly (Even when moved)?" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
		then
			# Make a copy of original config file
			sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.original
			dialog --title "Remove Mouse" \
			--clear \
			--sleep 3 \
			--infobox "Now going to back up the lightdm.conf file and edit the new lightdm.conf to remove mouse cursor."
			sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.DSbackup
			sudo sed -i 's/#xserver-command=X/xserver-command=X -nocursor/' /etc/lightdm/lightdm.conf
			break
		else
			if [ "${yn}" == "1" ];
				then
					break
			fi
		fi
	done

#########################################################

# Here we ask the user if they would like to change the RPi Memory split

	dialog --title "Memory Split" \
	--clear \
	--yesno "Would you like to change your Pi's Memory Split?\n\n(If you do not know what this means type choose NO)" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		while true; do
		_Mem_Val=$(dialog --title "Assign Memory" \
		--clear \
		--inputbox "Please enter the Memory Split you would like.\n\n(Must be one of the following values '64, 128, 256, 512' NOTE 64 is the default)" 0 0 2>&1 1>&3)
		_Mem_Rspns=$?
		case $_Mem_Rspns in
			0)
			if [ "$_Mem_Val" == "64" ] || [ "$_Mem_Val" == "128" ] || [ "$_Mem_Val" == "256" ] || [ "$_Mem_Val" == "512" ];
			then
				dialog --title "Memory Input" \
				--clear \
				--yesno "You have entered your desired memory split to be '$_Mem_Val', is that correct?" 0 0
				yn=$?
				if [ "${yn}" == "0" ];
				then
					_Mem_Set=$(cat /boot/config.txt | grep "gpu_mem=" >/dev/null)
					if [ "" == "$_Mem_Set" ];
					then
						dialog --title "Writing Config" \
						--clear \
						--sleep 3 \
						--infobox "Adding your new memory split to /boot/config file!" 0 0
						echo -e "\ngpu_mem=$_Mem_Val" | sudo tee -a /boot/config.txt >/dev/null
						break
					else
						dialog --title "Writing Config" \
						--clear \
						--sleep 3 \
						--infobox "Adding your new memory split to /boot/config file!" 0 0
						sudo sed -i "s/gpu_mem=[0-9]\+/gpu_mem=$_Mem_Val/" /boot/config.txt >/dev/null
						break
					fi
				fi
			fi;;
			1)
			dialog --title "Assign Memory" \
			--clear \
			--sleep 3 \
			--infobox "Your Pi's memory split will remain set to default values." 0 0
			break;;
		esac
	done
	else if [ "${yn}" == "1" ];
	then
		dialog --title "Memory Split" \
		--clear \
		--sleep 3 \
		--infobox "Your Pi's memory split will remain set the defualt values." 0 0
		break
	fi
fi

############################################################

# Here we ask the user if they would like to turn off the wifi power save feature

while true; do
	dialog --title "Wifi Power Save" \
	--clear \
	--yesno "Finally, would you like to turn off the wifi power save feature?\n\n(This is for Rpi's running Stretch and above, if you are running jessie or lower chose NO)" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		# Check to see if power manager is alread disabled
		_AlreadyOff=$(ls /etc/network/if-up.d/ | grep "off-power-manager")
		if [ "" == "$_AlreadyOff" ];
		then
			# Create the startup script needed
			dialog --title "Turn Off Wifi Power Save" \
			--clear \
			--sleep 3 \
			--infobox "Now going to create the needed startup script to disable wifi power save." 0 0
			echo -e "#!/bin/sh\n# off-power-manager - Disable the internal power manager of the (built-in) wlan0 device\niw dev wlan0 set power_save off" | sudo tee -a /etc/network/if-up.d/off-power-manager > /dev/null
			--sleep 2
			sudo chmod +x /etc/network/if-up.d/off-power-manager
			sudo /etc/init.d/networking restart
			iw dev wlan0 get power_save > /tmp/status
			dialog --title "Power Save Status" \
				--clear \
				--timeout 2 \
				--exit-label "" \
				--textbox /tmp/status 15 50
			rm /tmp/status
		else
			dialog --title "Power Save Status" \
			--clear \
			--sleep 3 \
			--infobox "Wifi Power Save feature is already disabled.  Nothing to do!" 0 0
			break
		fi
		break
	else
		if [ "${yn}" == "1" ];
		then
			break
		fi
	fi
done

##########################################################
while true; do
dialog --title "Thank You!" \
	--clear \
	--yes-label "Exit" \
	--no-label "Restart Now" \
	--yesno "All done!!\n\nPlease restart your Raspberry Pi now. Chromium will start in kiosk mode displaying the page you specified with the URL you specfied.\n\nThank you -JHart" 0 0
	yn=$?
	if [ "${yn}" == "0" ];
	then
		exit
	else if [ "${yn}" == "1" ];
	then
		sudo reboot
	fi
fi
done
