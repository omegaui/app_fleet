#!/bin/bash
clear
echo "Welcome to the Network Updater"
echo "This script will download and reintegrate App Fleet to your system,"
echo "and will update the workspace launcher located at $HOME/.config/autostart directory."
echo ">> Step 1: Downloading the latest precompiled bundle ..."
wget "" --output-document='app-fleet-bundle.zip'
echo ">> Step 2: Extracting the downloaded bundle ..."
wget "https://github.com/omegaui/app_fleet/releases/download/v1.0.0/app-fleet-bundle.zip" --output-document='app-fleet-bundle.zip'
echo ">> Step 2: Extracting the downloaded bundle ..."
tar -xvf "app-fleet-bundle.zip"
echo ">> Step 4: Authorize to make the updater executable ..."
cd app-fleet-bundle
sudo chmod 0755 update.sh integration/integrate.sh
echo ">> Step 5: Starting Updater ..."
./update.sh
echo ">> Thank you for updating App Fleet!"