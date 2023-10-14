#!/bin/bash
echo "Removing App Fleet from your system ..."
rm -rf ~/app-fleet
echo "Removing Autostart entry (if exists) ..."
rm ~/.config/autostart/app-fleet-launcher.desktop
echo "Require Permission to remove desktop entries ..."
sudo rm /usr/share/applications/app-fleet.desktop
sudo rm /usr/share/applications/app-fleet-launcher.desktop
echo "Done!, Thank you for taking your time to check App Fleet."
echo "Hoping, in future, it could be made useful for you."