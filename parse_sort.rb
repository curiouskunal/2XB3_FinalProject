require 'csv'
require_relative 'station.rb'
require_relative 'weather.rb'
# -format of inputCSV:
#                STATION,STATION_NAME,ELEVATION,LATITUDE,LONGITUDE,DATE,PRCP,TSUN,TMAX,TMIN
def main
  inputCSV = 'data/Testing.csv'

  fullList = Array.new
  temp = Array.new
  rain = Array.new

  current = ""
  currentStation = Station.new "0", "0", "0", "0", "0"

  CSV.foreach(inputCSV, headers:true) do |row|
    tmp = row[0].to_s
    if currentStation.code != tmp
      fullList.push(currentStation)
      currentStation = Station.new row[0], row[1], row[2], row[3], row[4]
    end
    currentStation.add_weather (Weather.new row[5], row[6], row[8], row[9])
  end

  for i in 0..fullList.size
    temp[i], rain[i] = 
  end

  sort temp
  sort rain

  puts temp
  puts ""
  puts rain
end

def sort list
  list.class == Array

  size = list.size - 1
  size.downto(0) do |i|
    heapify list, i, size
  end

  size.downto(1) do |i|
    list[0], list[i] = list[i], list[0]
    size = size - 1
    heapify list, 0, size
  end
end

def heapify x, i, n
  x.class == Array
  left = i * 2
  right = left + 1
  j = i

  if (left <=n && x[left] > x[j])
    j = left
  end
  if (right <= n && x[right] > x[j])
    j = right
  end

  if (j != i)
    x[i], x[j] = x[j], x[i]
    heapify x, j, n
  end
end

def getWearther value
  return value[6], [8]
end

main