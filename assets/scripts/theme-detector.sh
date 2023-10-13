#!/bin/bash
theme=$(gsettings get org.gnome.desktop.interface color-scheme | awk '{print $1}')
if [[ $theme == *dark* ]]; then
    exit 1
else
    exit 0
fi