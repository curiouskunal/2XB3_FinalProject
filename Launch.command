#!/bin/bash
echo "initializing Weather Station Analizer"
echo ""
echo ""

here="`dirname \"$0\"`"
cd "$here" || exit 1
cd ./Frontend

echo ""
echo ""

pwd


echo ""
echo ""

npm install
npm start

#osascript -e "tell application \"System Events\" to keystroke \"w\" using command down"