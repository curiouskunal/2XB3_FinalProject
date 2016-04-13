# author: Kunal Shah
# version: 1.4

class FilteringCSV
  require 'csv'

=begin

-String inputCSV is input CSV file name or location
-String outputCSV is output CSV file name or location

-format of inputCSV:
STATION,STATION_NAME,ELEVATION,LATITUDE,LONGITUDE,DATE,PRCP,TSUN,TMAX,TMIN

* Omitting TSUN data. *

=end

  def filterCSVdata(inputCSV, outputCSV, numOfDays)

    # set constants
    #numOfDays = 730 # 2 years
    tempFile = './data/tempCSV.csv'


    if File.exist?(outputCSV)
      File.delete(outputCSV)
    end

    puts "started filtering #{inputCSV} ..."
    CheckRows(inputCSV,tempFile)

    puts "getting valid stations ..."
    validStationsArr = GetValidStations(tempFile, numOfDays)

    puts "generating #{outputCSV} file ..."
    GenerateOutputFile(tempFile, outputCSV, validStationsArr)

    puts "deleting temp files ..."
    File.delete(tempFile)

    puts "Done!"
  end



  # method to check weather or not row has all data
  def isPrintLine(row)
    # loops through all values in row to check if data is missing.
    # missing data is indicated by "-9999"
    for i in 0..8
      if -9999 == row[i].to_i
        # found bad row
        return false
      end
    end
    return true
  end

  # Method checks each row in inputCSV for completeness then saves all good rows to outputCSV
  # Creates a temp file(outputCSV) to hold all valid rows of inputCSV
  def CheckRows(inputCSV,outputCSV)

    # open inputCSV file and iterate row by row
    CSV.foreach(inputCSV) do |row|

      # by default we want to save row unless changed
      saveLine = true

      #isPrintLine returns bool. true = stores whether or not the line will be printed
      saveLine = isPrintLine(row)

      # if saveline is true. Then save row to output CSV file
      if saveLine
        open(outputCSV, 'a') { |f| f.puts row.join(",")}
      end

    end

  end

  # Method checks if there are enough days of data for each station.
  # if a Station has "requiredDays" of data then add to validStations array
  # returns validStations
  def GetValidStations(inputCSV, requiredDays )

    # initialize variables
    validStations = []
    currentStation = ""
    stationCounter = 0

    CSV.foreach(inputCSV, headers:true) do |row|

      # set station ID
      stationID = row[0].to_s

      # if stationID doesnt match currentStation then
      if stationID != currentStation

        # check if station has enough data and append to array
        if stationCounter >= requiredDays
          validStations.push(currentStation)
        end

        # set new current station and reset counter to 0.
        currentStation = stationID
        stationCounter = 0
      end
      # increment counter
      stationCounter += 1

    end

    # append last "current station" if it has enough days of data
    if stationCounter >= requiredDays
      validStations.push(currentStation)
    end

    # return array of stations that have enough days of data.
    return validStations
  end

  # Method to append all valid station's data points to final filtered output file
  def GenerateOutputFile(inputCSV, outputCSV, validStations)

    printHeaders = false

    CSV.foreach(inputCSV) do |row|
      # append header line only once to file
      if !printHeaders
        open(outputCSV, 'a') { |f| f.puts row.join(",")}
        printHeaders = true
      end

      # if StationID is in validStations list then add row to output file
      if validStations.include?(row[0])
        open(outputCSV, 'a') { |f| f.puts row.join(",")}
      end

    end

  end

end

#--------------------------#
# Removed autoRunning Code #
#--------------------------#
=begin
# --- MAIN ---

x = FilteringCSV.new
#
# # Run filter on Testing.csv
# x.filterCSVdata('data/Testing.csv', 'data/testingFinal.csv',30)

# Run filter on Full dataset
x.filterCSVdata('data/california.csv','data/caliFinal.csv',730)
=end