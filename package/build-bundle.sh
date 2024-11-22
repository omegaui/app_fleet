#!/bin/bash
# Requires Flutter 3.13.7 or any compatible version
# Replace [flutter] with the exact path of the sdk if you have
# more than one flutter sdk versions installed.
cd ..
echo "Do you have more than one flutter sdk installed? Or Does your SDK version is greater than 3.13.7? then, in that case, please make sure you check 'package/build-bundle.sh' file."
echo "Press any key to continue with building using the default Flutter SDK ..."
read
echo "> Building Linux Bundle ..."
flutter build linux --release
echo "> Removing Old Bundle ..."
rm -rf package/integration/bundle/*
echo "> Copying Bundle ..."
cp -r build/linux/x64/release/bundle/* package/integration/bundle
echo "> Ready for Integration"
