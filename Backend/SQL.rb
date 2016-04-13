require 'sqlite3'
require 'csv'
require_relative 'station.rb'
require_relative 'weather.rb'


class SQL
  # variables used throughout code
  @db = SQLite3::Database.open "California.db"
  @validStations = Hash.new
  @invalidStation = Hash.new


  def self.makeSQL
    # creating the a table if it doesnt exist
    @db.execute "CREATE TABLE IF NOT EXISTS Station (Id String PRIMARY KEY,
         Name TEXT, Latitude DOUBLE, Longitude DOUBLE, Elevation DOUBLE)"

    # reading the file names in folder
    dirArray = Dir.entries("ORIGINAL DATA")
    dirArray = dirArray[2..dirArray.length]

    # creating a new array
    used = Array.new

    # add the information in the file into the array
    File.foreach('Used Data.txt') do |row|
      used.push(row.chomp)
    end

    # puts "Started"
    # opening the file and allowing to append if needed
    open('Used Data.txt', 'a') do |f|
      # for all elements in the directory
      for i in dirArray
        # if file has not been read yet
        if !used.include? i
          # for all rows in the csv file
          CSV.foreach('ORIGINAL DATA/' + i, headers: true) do |row|
            # reading the row of the csv file
            id = row[0].to_s
            name = row[1].to_s
            elev = row[2].to_f
            lat = row[3].to_f
            long = row[4].to_f
            date = row[5].to_i
            prec = row[6].to_i
            tMAX = row[7].to_i
            tMIN = row[8].to_i

            # shortening the ID
            id = id[6..id.length]
            # creating the params variable to pass into the sql
            params = id, name, lat, long, elev
            # get the number of stations where it exists in the table
            stm = @db.execute "SELECT COUNT(Id) AS STATIONEXISTS FROM Station WHERE Id=?", id
            # create a new table with the name of the station id
            @db.execute "CREATE TABLE IF NOT EXISTS #{id} (Id INTEGER PRIMARY KEY, Precipitation INTEGER, Temp_Max INTEGER, Temp_Min INTEGER)"
            # if the value was not already in the table
            if stm[0][0] == 0
              # insert this station data into the table
              @db.execute "INSERT INTO Station VALUES(?,?,?,?,?)", params
            end
            # change the data passed
            params = date, prec, tMAX, tMIN
            # if the the number of times the date is in the table
            stm = @db.execute "SELECT COUNT(Id) AS #{id}EXISTS FROM #{id} WHERE Id=?", date
            # if it doesn't exist in the table
            if stm[0][0] == 0
              # insert it into the table
              @db.execute "INSERT INTO #{id} VALUES(?,?,?,?)", params
            end
          end
          # add the name of the file to the text file
          f.puts i
        end
      end
    end
    puts "Done"

      # catch any errors
  rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

  ensure
    # close the database
    @db.close if @db
  end

  def self.getValid input, period
    # the startYear value is 2000. The value will need to be multiplied by 1000
    startYear = input * 10000
    # the tolerance is 3 years. This is the (startYear + period) * 1000 + 9999
    endYear = (input + period - 1) * 10000 + 9999
    # get the information from the Station
    stm = @db.execute "SELECT Id FROM Station"
    # for all the ids in the Station table
    for stationID in stm
      # get the dates (id) from a Station table where neither data has -9999 in it and the ID is between the startYear and endYear
      data = @db.execute "SELECT Id FROM #{stationID[0]} WHERE Precipitation!=-9999 AND Temp_Max!=-9999 AND Temp_Min!=-9999 AND Id BETWEEN #{startYear} AND #{endYear}"
      # as long as data exists
      if (data.length != 0)
        # if the length of the date is the days between the two periods
        if (data.length >= self.daysBetween(input, period-1))
          # add it to the valid stations hash
          @validStations[stationID[0]] = data
        end
        # add the data to the invalid stations
        @invalidStation[stationID[0]] = data
      end
    end
  end

  def self.parse start, period
    # get the valid data
    self.getValid start, period
    # create two new arrays that will be passed
    stationList = Array.new
    badStationList = Array.new
    # get the ids
    ids = @db.execute "SELECT Id FROM Station ORDER BY Id"
    # get all the station data
    stationInfo = @db.execute "SELECT * FROM Station ORDER BY Id"
    # counter variable
    i = 0
    # iterate through all the values in ids
    for stationID in ids
      # if the hash doesnt fail
      if @invalidStation[stationID[0]] != nil
        # create a new station with the information
        currentStation = Station.new stationInfo[i][0], stationInfo[i][1], stationInfo[i][4], stationInfo[i][2], stationInfo[i][3]
        # if the hash doesnt fail
        if @validStations[stationID[0]] != nil
          # for all dates in validStations at the id in the hash
          for date in @validStations[stationID[0]]
            # get the row with the particular date
            data = @db.execute "SELECT * FROM #{stationID[0]} WHERE Id = ?", date
            # add it to the weather information of the station
            currentStation.add_weather Weather.new data[0][0].to_s, data[0][1].to_s, data[0][2].to_s, data[0][3].to_s
          end
          # add the station to the station lists
          stationList.push currentStation
        #   it fails the valid stations hash
        else
          # for all dates in invalidStations at the id in the hash
          for date in @invalidStation[stationID[0]]
            # get the row with the particular date
            data = @db.execute "SELECT * FROM #{stationID[0]} WHERE Id = ?", date
            # add it to the weather information of the station
            currentStation.add_weather Weather.new data[0][0].to_s, data[0][1].to_s, data[0][2].to_s, data[0][3].to_s
          end
          # add the station to the station lists
          badStationList.push currentStation
        end
      end
      # increment the counter
      i += 1
    end

    return stationList, badStationList
  end

  def self.daysBetween startYear, period
    # the total days in the period accounting for leap years
    days = 0
    i = 0
    # from 0 to period
    for i in 0..period
      # case for leap year
      if startYear%4 == 0
        if startYear%100 == 0
          if startYear%400 == 0
            days+=1
          end
        end
      end
      # add 365 days for a year
      days+=365
      # increment the startYear which represents the year
      startYear+=1
    end
    # return the integer
    return days.to_i
  end
end