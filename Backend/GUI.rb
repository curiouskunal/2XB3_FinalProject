# author: Kunal Shah
# version: 2.0
Shoes.app :title => "Filter CSV", width: 600 do

  class Actions
    @myApp

    def initialize(myApp)
      @myApp = myApp
    end

    require 'csv'

=begin

-String inputCSV is input CSV file name or location
-String outputCSV is output CSV file name or location

-format of inputCSV:
STATION,STATION_NAME,ELEVATION,LATITUDE,LONGITUDE,DATE,PRCP,TSUN,TMAX,TMIN

* Omitting TSUN data. *

=end

    def doFilter (inputCSV, outputCSV, numOfDays)

      # set constants
      #numOfDays = 730 # 2 years
      tempFile = 'data/tempCSV.csv'

      if File.exist?(outputCSV)
        File.delete(outputCSV)
      end

      # puts "started filtering #{inputCSV} ..."
      CheckRows(inputCSV,tempFile)

      # puts "getting valid stations ..."
      validStationsArr = GetValidStations(tempFile, numOfDays)

      # puts "generating #{outputCSV} file ..."
      GenerateOutputFile(tempFile, outputCSV, validStationsArr)

      # puts "deleting temp files ..."
      File.delete(tempFile)

      return validStationsArr
      # puts "Done!"
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


  #### GUI ####


  @myFilter = Actions.new(self)
  @goodList = []


  stack do
    style(:margin_left => '32%', :margin_top => '5%')
    # inText = edit_line
    # outText = edit_line

    para "Input file"
    inText = list_box items: ["Testing" , "california"]
    para "Temp Tolerance"
    tempText = edit_line

    para "Precipitation Tolerance"
    rainText = edit_line

    button "run the program" do
      # Run filter on Testing.csv

      input = "data/"+inText.text.to_s+".csv"
      temp = tempText.text.to_s.to_i(10)
      rain = rainText.text.to_s.to_i(10)

      if inText.text.to_s == "Testing"
        days = 30
        @badList = ["GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002","GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010"]
      else
        days = 730
        @badList = ["GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010""GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010""GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010","GHCND:US1CAMT0008","GHCND:US1CAIN0006","GHCND:US1CAIN0005","GHCND:US1CAIN0002",
                    "GHCND:USC00041159","GHCND:USC00046602","GHCND:US1CASH0010"]
      end

      @goodList = @myFilter.doFilter(input,"data/CSVout.csv",days)

      alert "done! with Temp Tolerance: #{temp} and Precipitation Tolerance #{rain}"


      flow do
        stack width: 300 do
          style(:margin_left => '5%', :margin_right => '5%')
          background white
          caption "Good Stations"
          para @goodList.join("\n"), stroke: green
        end
        stack width: -300 do
          style(:margin_left => '5%', :margin_right => '5%')
          background white
          caption "Bad Stations"
          para @badList.join("\n"), stroke: red

        end
      end
    end
  end
end

