###### 2XB3 Final Project: Group 25
# Weather Station Analizer

## How to run?
####Initializing program:
Have node installed either through homebrew: `brew install node`
or from the website: <https://nodejs.org/en/download/>

On a unix computer run `Initialize.command` by either 
using terminal or double clicking in file explorer
this will intall all dependencies and launch program
####run program:
After initializing you can use `Launch.command` to run program after first launch.

## Modle - View - Contoler:

	Back-End: Ruby
	Front-End: electron wraped html and javascript
	Controler: Sinatra Ruby server  

## Dataset:


## 2 Weeks:

	- Application
	- run form console
	- takes in file name
	- takes in tolerance level xdegree temp, %rain likliness
	- claculations
	- output, a graph of stations that are left and of all stations

## I/O:



### Output:
	- ruby shoes graphics, to show connections
	- list of neded and uneeded

## Algorthims:

### Parsing:
	- parse stations into, weather station objects. 
	- each object has day object

### % days - Calculations:
	- % days temp in tolerance
	- % days rain in tolerance

### Searching/filter:
	- remove stations that do not ahve data we need
	- move valid objects into new file

### Sorting:
	- sort edges by, percentage tolerance after calulcating 
	- efficent low memorey
	- user specifes amount: ex.
	- temp is between x degrees y percent of time
	- same with rain chance

### Graphing:
	- split area into grid, than graph within grid block, anyblock in radius is searched vs. whole map

### Relatdness Percentage:
	- servie value?
	- after calulcated. for each node sort and list. than delete any connections within toleracne since they are too similar.
	- At the end if a sation ahs no connections going to it is uneeded

## ADT:

### Station Object:
- Day object array - to hold data from that row in csv
- Node: to hold the connections that will be made, and the %similarity based on given tolerances.
- Variables:
    - object ID
    - memory id
    - logitude and latitude
    - increment connections
    - decrement connections
    - connections variable


### Day:

	- date
	- percp
	- temp
	- high, low temp
	- weather info

### Edge:

	- start - station
	- end - station
	- Percentage Tolerances - 
	- everytime an edge is contructed increment station object connections by 1
	- calculations algorthim