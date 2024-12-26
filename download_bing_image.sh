#!/bin/bash

wget -q -O - "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" | \
grep -oP '"url":"\K[^"]+' | \
sed 's/^/https:\/\/www.bing.com/' | \
xargs wget -q -O ~/Pictures/bing_background.jpg

gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/Pictures/bing_background.jpg"
gsettings set org.gnome.desktop.background picture-options "zoom"
