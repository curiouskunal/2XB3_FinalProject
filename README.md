###### 2XB3 Final Project: Group 25
# Weather Station Analizer

## How to run?
#### Initializing program:
Have node installed either through homebrew: `brew install node`
or from the website: <https://nodejs.org/en/download/>

On a unix computer run `Initialize.command` by either
using terminal or double clicking in file explorer
this will intall all dependencies and launch program
#### run program:
After initializing you can use `Launch.command` to run program after first launch.

## Modle - View - Contoler:

	Back-End: Ruby
	Front-End: electron wraped html and javascript
	Controler: Sinatra Ruby server

## Dataset:
30 years of weather data for California from:
[National Climatic Data Center](http://www.ncdc.noaa.gov/cdo-web/search)

example data point:

STATION | STATION_NAME | ELEVATION | LATITUDE | LONGITUDE | DATE | PRCP | TMAX | TMIN
--- | --- | --- | --- | --- | --- | --- | ---
GHCND:USR0000CTHO | THOMES CREEK CALIFORNIA CA US | 317 | 39.8644 | -122.6097 | 20020103 | 2 | 150 | 78

All data parced into SQLit3 database

## I/O:
#### Input
	- Start Year
	- Sample Period
	- Tolerences
	- Temperature
	- Precipitation
	- Accuracy Rating
#### Output
	- Visual map with stations to keep and remove
	- CSV file with more details


# Scrum:
## Sprint 1
	-CSV Parsing and Data Filtering
	-Created Edges, with distance weights
	-Initial Graphing
	-Basic UI - in Ruby shoes
## Sprint 2
	- Ported Filter and Parsing to SQLite3
	- Implemented Rest Server
	- Finalized HTML doc for Electron Wrapper