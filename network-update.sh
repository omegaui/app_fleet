#!/bin/bash
clear
echo "Welcome to the Network Updater"
echo "This script will download and reintegrate App Fleet to your system,"
echo "and will update the workspace launcher located at $HOME/.config/autostart directory."
echo ">> Step 1: Downloading the latest precompiled bundle ..."
wget "" --output-document='app-fleet-bundle.zip'
echo ">> Step 2: Extracting the downloaded bundle ..."
tar xvcf "app-fleet-bundle.zip"
echo ">> Step 3: Removing the downloaded bundle to save space ..."
rm "app-fleet-bundle.zip"
echo ">> Step 4: Authorize to make the updater executable ..."
cd app-fleet-bundle
sudo chmod 0755 update.sh integration/integrate.sh
echo ">> Step 5: Starting Updater ..."
./install.sh
echo ">> Thank you for updating App Fleet!"