#!/bin/bash

# launch commands script for Weather Station Analyzer

# get current directory
here="`dirname \"$0\"`"
# set current directory to frontend 
cd "$here" || exit 1
cd ./Frontend

echo "Starting Weather Station Analizer"

# starting program
npm start
