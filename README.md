# 2XB3:

## Languages:

Back-End: Ruby and Ruby on rails
Front-End: To be decided, electron?

## 2 Weeks:

	- Application
	- run form console
	- takes in file name
	- takes in tolerance level xdegree temp, %rain likliness
	- claculations
	- output, a graph of stations that are left and of all stations

## I/O:

### Input:
	- Parsing csv file
	- take in tolerance

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

# SCRUM:

- Sprint: Feb 29 to Wed Mar 2

## Stories: 

- Filter: 					Kunal
- Parsing + Sorting:  		Pareek
- Station + Days: 			Pedro
- Edges + %days calulations:	Pavi