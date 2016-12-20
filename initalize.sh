#!/bin/bash

control_c(){
	tput cup $(tput lines) 0
	echo -e "\033[0m"
	exit
}

trap control_c INT

# launch commands script for Weather Station Analyzer
echo -e "\033[32m"
clear
tput cup 0 0
echo "Initializing Weather Station Analyzer"
echo "-------------------------------------"
echo -e "\033[1;37m"

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
echo -n "Bundler installed: "
#if bundler not installed then install it
if ! gem list bundler -i; 
then 
echo "Installing Bundler"
sudo gem install --no-rdoc --no-ri bundler;
echo ""
fi
echo -e "\033[1;37m Installing required gems"
bundle install
echo -e "\033[1;37m Installing required node packages"
npm install

echo -e "\033[1;37m Extracting Database"
# unzip Databse
cd .././Backend
touch ./California.db
rm ./California.db
tar -xvzf ./California.zip
cd .././Frontend

echo -e "\033[32m"
echo "-------------------------------------"
echo "You are ready to go"
echo -e " \033[0m"

# hide terminal after quit
#osascript -e "tell application \"System Events\" to keystroke \"w\" using command down"