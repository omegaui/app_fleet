#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: integrate.sh [install|update]"
  exit 1
fi

mode="$1"

if [ "$mode" == "install" ]; then
  echo "Starting Integration in Install/Reinstall Mode ..."
  rm -rf $HOME/app-fleet
  mkdir $HOME/app-fleet
elif [ "$mode" == "update" ]; then
  echo "Starting Integration in Update Mode ..."
  rm -rf $HOME/app-fleet/data
  rm -rf $HOME/app-fleet/lib
  rm $HOME/app-fleet/app_fleet
else
  echo "Unknown integration mode: \"$mode\""
  exit 127
fi

echo "> Copying App Bundle to User Home ..."
cp -r bundle/* $HOME/app-fleet
echo "> Authorize to write executables"
sudo cp app-fleet /usr/bin/app-fleet
sudo chmod 0755 /usr/bin/app-fleet
echo "> Adding Desktop Entries ..."
sudo cp icons/* /usr/share/pixmaps
sudo cp desktop-entries/* /usr/share/applications
echo "> Adding Launcher to autostart ..."
sudo cp desktop-entries/app-fleet-launcher.desktop $HOME/.config/autostart
echo "> Integration Successful"