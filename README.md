<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width,initial-scale=1.0">
		<title>RpiKiosk</title>
		<link rel="stylesheet" media="screen and (min-width: 600px)" href="./css/style.css" />
		<link rel="stylesheet" media="screen and (max-width: 599px)" href="./css/mstyle.css" />
	</head>
	<?php if(($_POST['blog'])){
	header("Location: blogList.php");}?>
<h1><b>FIX README FOR BUSTER AND UPDATED DEB FILE WHEN READY</b></h1></br></br></br>
	<body>
		<table id="title">
			<tr>
				<td id="title">
					<h1>Creating Easy Digital Sign With Raspberry Pi 3</h1>
				</td>
			</tr>
		</table>
		<table id="blog">
			<tr>
				<td id="blog">
					<p id="blog"><h2><strong>How To</strong></h2></p>
					<p id="blog"><b>***NOTE*** This tutorial is for the GUI Version of RpiKiosk.  I will write up a different tutorial for the CLI Version.</br>This program and this tutorial were designed for use with a raspberry pi 2 or 3 with armhf architecture.</br><s>This program was based on the 2017-11-29-raspbian-stretch version of raspbian.</s> EDIT: Code has been updated to work with new 2018-11-13-raspbian-stretch version of raspbian.</b></br></p>
					<p id="blog">1. The first thing you will need to do is install Raspian onto your raspberry pi.  To Install Raspian Stretch to your pi please go to <a href="https://www.raspberrypi.org/downloads/raspbian/">https://www.raspberrypi.org/downloads/raspbian/</a> and follow the instructions there.</br></p>
					<p id="blog">2. Next, the gui version of this tool does have a dependency to work correctly.  You will need to install the "dialog" package in order to use the GUI version of this tool. You can install "dialog" using the following command on your Pi in the terminal:</br></p>
					<code><pre>$ sudo apt-get install dialog</pre></code>
					<p id="blog">3. There are also a few packages that these scripts do not directly depend on but will help the user should the want to make further changes.  The RpiKioskInstall script will look for these and install them if they are not found on your pi.  However, if you wish to install them before running the script then run the following commands on your pi in the terminal:</br></p>
					<code><pre>$ sudo apt-get update
$ sudo apt-get install git vim clutter</pre></code>
					<p id="blog">The "git" package is for users that are familiar with using git and want to clone the RpiKiosk Repository rather than downloading the zip file.</br>The "vim" package is simply a terminal text editor.  This package is not crucial but will be of benefit if you are an advanced linux or pi user.</br>The "clutter" package will hide your pi's mouse cursor when it is not being used.  This is good for locations that your kiosk or digital sign will not be within reach of public.  In the case that your kiosk or digital sign is within reach of public, the RpiKioskCursorDisable script will allow you to completely disable your mouse cursor on your pi. (This can be reverted using the RpiKioskCursorEnable script)</br></p>
					<p id="blog"><h2><strong>DEB PACKAGE USE ONLY</strong></h2></p>
					<p id="blog">If you wish to download the deb package version download the file then run the following commands: <a href="https://github.com/jharttech/RpiKiosk/raw/master/files/RpiKiosk_1.1-0.deb">rpikiosk_1.2-0.deb</a></br></p>
					<code><pre>$ cd /path/to/downloaded/rpikiosk_1.2-0.deb
$ sudo dpkg -i RpiKiosk_1.1-0.deb</pre></code>
					<p id="blog">If the install fails and complains about a dependency the install the "dialog" package using:</br></p>
					<code><pre>$ sudo apt-get -f install
$ sudo dpkg -i RpiKiosk_1.1-0.deb</pre></code>
					<p id="blog">Now you can simply run the following command in the terminal and follow on-screen prompts and options.</br></p>
					<code><pre>$ RpiKioskMain</pre></code>
					<p id="blog">From here you can select what you would like to do: Install, Uninstall, Enable Mouse, Disable Mouse.</br></p>
					<p id="blog"><h2><strong>RUN RPIKIOSK FROM CLONE OR ZIP DOWNLOAD</strong></h2></p>
					<p id="blog">1. Clone the RpiKiosk Repository from https://github.com/jharttech/RpiKiosk.git:</br></p>
					<code><pre>$ git clone https://github.com/jharttech/RpiKiosk.git</pre></code>
					<p id="blog">OR</p>
					<p id="blog">1. Download the RpiKiosk zip file from <a href="https://github.com/jharttech/RpiKiosk/archive/master.zip">https://github.com/jharttech/RpiKiosk/archive/master.zip</a> to your pi, then extract the files:</br></p>
					<code><pre>$ cd /path/to/downloaded/RpiKiosk-master.zip
$ mkdir /home/pi/RpiKiosk
$ mv RpiKiosk-master.zip /home/pi/RpiKiosk
$ cd /home/pi/RpiKiosk</pre></code>
					<p id="blog">2. Go into the RpiKiosk folder and move files to the correct location.</br></p>
					<code><pre>$ cd /home/pi/RpiKiosk
$ sudo mv Rpi* /usr/local/bin/
$ sudo mv logo.txt /usr/local/bin/</pre></code>
					<p id="blog">3. Run the Install Script (If you did not download the deb package version)</br></p>
					<code><pre>$ cd /usr/local/bin
$ chmod +x RpiKioskMain.sh
$ ./RpiKioskMain</pre></code>
					<p id="blog">From the Main menu you can select what you would like to do.  You can choose between: Install, Uninstall, Enable Mouse, Disable Mouse.<br>Install: This will start the Installation script and will walk you through the setup of your kiosk or digital sign.  Simply followw the script and answer with the desired inputs.  Once the script has finished you should restart your pi for the changes to take effect.<br>(If you downloaded and installed the deb package version of the RpiKiosk please refer to the "DEB PACKAGE ONLY" section above.</br></p>
					<p id="blog"><h2><strong>NOTES</strong></h2><p>
					<p id="blog">In the Main menu you can choose between: Install, Uninstall, Enable Mouse, Disable Mouse. Install: This will start the Installation script and will walk you through the setup of your kiosk or digital sign. Simply follow the script and answer with the desired inputs. Uninstall: This will start the Uninstall script and will revert all config files back to the pi defaults. Enable Mouse: This will start the Enable Mouse script. If you disabled the mouse during initial installation this will re-enable your mouse cursor without uninstalling the kiosk. Disable Mouse: This will start the Disable Mouse script. If you did not disable the mouse during initial installation this will allow you to do so should you feel the need.</br></p>
					<p id="blog">I recommend you setting up a free Dakboard account at <a href="https://dakboard.com/site">https://dakboard.com/site</a>. This company will help you quickly set up a nice digital display for free. (The free version is limited on customizations)</br></p>
					<p id="blog">Screen Orientation: This setting is dependant upon which way your digital sign (monitor or TV) is mounted. Your options are "Landscape" or Portrait".</br></p>
					<p id="blog">Enter your URL: The Install script will ask you for a URL to your kiosk, video, or slideshow. If you are using DAKBoard, you will find this url under your account settings. If will be called your Private URL. If you are using google slides this will be your public published URL. This URL can be a URL to any type of legal media that you wish to display on your digital sign.</br></p>
					<p id="blog">Disable Mouse Cursor: The Install script will ask if you would like to disable your mouse cursor. If you choose to do so, you can revert this at a later date by running the EnableCursor.sh script. If you choose not to disable the mouse cursor during install, you can disable it later by running the DisableCursor.sh script.</br></p>
					<p id="blog">Memory Split: The Install script will ask if you would like to change the memory split of your pi. If you do not know what this means please indicate that you would not like to change this value by entering "NO" when prompted. You can change this later by running the "$ raspi-config" command.</br></p>
					<p id="blog">How to get to the terminal once you have installed the kiosk: You may want to run other scripts or exit out of your newely created Kiosk. To do this on your pi, press the "windows" key on your keyboard. Next arrow down to "Accessories", arrow to the right one time, then arrow down to terminal and press the "enter" key. Once the terminal is up, type the following command to stop the Kiosk:</br></p>
					<code><pre>$ killall chromium-browsers</pre></code>
					<p id="blog">(This will stop the kiosk and allow you to run other scripts or use your pi how ever you desire).</br></p>
					<p id="blog"><h2><strong>UNINSTALL</strong></h2></p>
					<p id="blog">To uninstall the kiosk simply return to the terminal and run RpiKioskMain, then select the "Uninstall" option.  This script will revert all config files back to the original states and will enable the mouse if it has been disabled.</br></p>
					<p id="disclaim"><b>IN NO EVENT WILL WE BE LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, SPECIAL OR EXEMPLARY DAMAGES FOR ANY USE OF THIS SITE, OR USE OF ANY OTHER LINKED SITE, OR SOFTWARE, EVEN IF WE ARE ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.</b></br></br></p>
</html>
