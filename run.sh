#!/bin/bash

# launch commands script for Weather Station Analyzer

# get current directory
here="`dirname \"$0\"`"
# set current directory to frontend 
cd "$here" || exit 1
cd ./Frontend

#move to top of screen
clear
tput cup 0 0 

echo -en "\033[1;32m"
echo "Starting Weather Station Analizer"
echo "-------------------------------------"
echo -e " \033[0m"

echo '{"Graphs":false, "Cutting":false, "Testing":false, "loading":false}' >> ../Backend/load.json
echo "File Made"
# starting program
npm start

echo -e "\033[1;32m"
echo "-------------------------------------"
echo "Good Bye"
echo -e " \033[0m"