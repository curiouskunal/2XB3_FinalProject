#!/bin/bash

# launch commands script for Weather Station Analyzer

echo "initializing Weather Station Analizer"
echo ""

# get current directory
here="`dirname \"$0\"`"
# set current directory to frontend 
cd "$here" || exit 1
cd ./Frontend

# display current dir location to console
pwd

echo ""

echo "Installing all dependencies"
echo ""

sudo gem install --no-rdoc --no-ri bundler
bundle install
npm install

# unzip Databse
cd .././Backend
touch ./California.db
rm ./California.db
tar -xvzf ./California.zip
cd .././Frontend

echo ""
echo "You are ready to go"

# hide terminal after quit
#osascript -e "tell application \"System Events\" to keystroke \"w\" using command down"