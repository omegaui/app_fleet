#!/bin/bash
cd ..
echo "> Building Linux Bundle ..."
flutter build linux --release
echo "> Copying Bundle ..."
cp -r build/linux/x64/release/bundle/* package/integration/bundle
echo "> Ready for Integration"