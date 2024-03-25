#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: integrate.sh [install|update]"
	exit 1
fi

mode="$1"

if [ "$mode" == "install" ]; then
	echo "Starting Integration in Install/Reinstall Mode ..."
	rm -rf $HOME/.config/app-fleet
	mkdir $HOME/.config/app-fleet
elif [ "$mode" == "update" ]; then
	echo "Starting Integration in Update Mode ..."
	rm -rf $HOME/.config/app-fleet/data
	rm -rf $HOME/.config/app-fleet/lib
	rm $HOME/.config/app-fleet/app-fleet
else
	echo "Unknown integration mode: \"$mode\""
	exit 127
fi

echo "> Creating Local Install Directories ..."
sudo mkdir -p /usr/local/bin /usr/local/share/applications /usr/local/share/pixmaps

echo "> Copying App Bundle to User Home ..."
cp -r bundle/* $HOME/.config/app-fleet
echo "> Authorize to write executables"
sudo cp app-fleet /usr/local/bin/app-fleet
sudo chmod +x /usr/local/bin/app-fleet
echo "> Adding Desktop Entries ..."
sudo cp icons/* /usr/local/share/pixmaps
sudo cp desktop-entries/* /usr/local/share/applications
echo "> Adding Launcher to autostart ..."
sudo cp desktop-entries/app-fleet-launcher.desktop $HOME/.config/autostart
echo "> Integration Successful"
echo "> Removing release data if any"
rm -rf $HOME/.config/app-fleet-releases
echo ">> App Fleet is all set to use !!"
echo "Press enter to exit ..."
read

