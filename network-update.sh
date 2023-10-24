#!/bin/bash
clear
echo "Welcome to the Network Updater"
echo "This script will download and reintegrate App Fleet to your system,"
echo "and will re-add the workspace launcher to $HOME/.config/autostart directory."
echo ">> Step 1: Downloading the latest precompiled bundle ..."
mkdir app-fleet-bundle
cd app-fleet-bundle
wget "https://github.com/omegaui/app_fleet/releases/download/v1.0.0%2B8/app-fleet-bundle.zip" --output-document='app-fleet-bundle.zip'
echo ">> Step 2: Extracting the downloaded bundle ..."
unzip "app-fleet-bundle.zip"
echo ">> Step 3: Removing the downloaded bundle to save space ..."
rm "app-fleet-bundle.zip"
echo ">> Step 4: Authorize to make the updater executable ..."
sudo chmod 0755 update.sh integration/integrate.sh
echo ">> Step 5: Starting Installer ..."
./update.sh
echo ">> Step 6: Removing Extracted Bundle ..."
cd ..
rm -rf app-fleet-bundle
echo ">> Thank you for updating App Fleet!"