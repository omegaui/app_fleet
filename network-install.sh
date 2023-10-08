#!/bin/bash
clear
echo "Welcome to the Network Installer"
echo "This script will download and integrate App Fleet to your system,"
echo "and will add the workspace launcher to $HOME/.config/autostart directory."
echo ">> Step 1: Downloading the latest precompiled bundle ..."
wget "https://github.com/omegaui/app_fleet/releases/download/v1.0.0/app-fleet-bundle.zip" --output-document='app-fleet-bundle.zip'
echo ">> Step 2: Extracting the downloaded bundle ..."
tar -xvf "app-fleet-bundle.zip"
echo ">> Step 3: Removing the downloaded bundle to save space ..."
rm "app-fleet-bundle.zip"
echo ">> Step 4: Authorize to make the installer executable ..."
cd app-fleet-bundle
sudo chmod 0755 install.sh integration/integrate.sh
echo ">> Step 5: Starting Installer ..."
./install.sh
echo ">> Thank you for installing App Fleet!"