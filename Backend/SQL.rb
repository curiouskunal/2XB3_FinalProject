require 'sqlite3'
require 'csv'
require_relative 'station.rb'
require_relative 'weather.rb'


class SQL
  @db = SQLite3::Database.open "California.db"
  @validStations = Hash.new
  @invalidStation = Hash.new


  def self.makeSQL
    # puts @db.get_first_value 'SELECT SQLITE_VERSION()'

    @db.execute "CREATE TABLE IF NOT EXISTS Station (Id String PRIMARY KEY,
         Name TEXT, Latitude DOUBLE, Longitude DOUBLE, Elevation DOUBLE)"

    dirArray = Dir.entries("ORIGINAL DATA")
    dirArray = dirArray[2..dirArray.length]

    used = Array.new

    File.foreach('Used Data.txt') do |row|
      used.push(row.chomp)
    end

    # puts used
    # puts used.include? "cal0001.csv"

    puts "Started"
    open('Used Data.txt', 'a') do |f|
      for i in dirArray
        # puts i
        if !used.include? i
          CSV.foreach('ORIGINAL DATA/' + i, headers: true) do |row|
            id = row[0].to_s
            name = row[1].to_s
            elev = row[2].to_f
            lat = row[3].to_f
            long = row[4].to_f
            date = row[5].to_i
            prec = row[6].to_i
            tMAX = row[7].to_i
            tMIN = row[8].to_i

            id = id[6..id.length]
            params = id, name, lat, long, elev

            stm = @db.execute "SELECT COUNT(Id) AS STATIONEXISTS FROM Station WHERE Id=?", id

            @db.execute "CREATE TABLE IF NOT EXISTS #{id} (Id INTEGER PRIMARY KEY, Precipitation INTEGER, Temp_Max INTEGER, Temp_Min INTEGER)"

            if stm[0][0] == 0
              @db.execute "INSERT INTO Station VALUES(?,?,?,?,?)", params
              # puts id.to_s + " " + name.to_s + " " + long.to_s + " " + lat.to_s + " " + elev.to_s
            end
            params = date, prec, tMAX, tMIN

            stm = @db.execute "SELECT COUNT(Id) AS #{id}EXISTS FROM #{id} WHERE Id=?", date
            if stm[0][0] == 0
              @db.execute "INSERT INTO #{id} VALUES(?,?,?,?)", params
            end
          end
          f.puts i
        end
      end
    end

    # self.parse

    puts "Done"


  rescue SQLite3::Exception => e

    puts "Exception occurred"
    puts e

  ensure
    # stm.close if stm
    @db.close if @db
  end

  def self.getValid input, period

# the startYear value is 2000. The value will need to be multiplied by 1000
    startYear = input * 10000
# the tolerance is 3 years. This is the (startYear + period) * 1000 + 9999
    endYear = (input + period - 1) * 10000 + 9999
    stm = @db.execute "SELECT Id FROM Station"
    previous = Array.new
    for stationID in stm
      data = @db.execute "SELECT Id FROM #{stationID[0]} WHERE Precipitation!=-9999 AND Temp_Max!=-9999 AND Temp_Min!=-9999 AND Id BETWEEN #{startYear} AND #{endYear}"
      if (data.length != 0)
        if (data.length >= self.daysBetween(input, period-1))
          @validStations[stationID[0]] = data
        end
        @invalidStation[stationID[0]] = data
      end
    end
  end

  def self.parse start, period
    self.getValid start, period
    stationList = Array.new
    badStationList = Array.new

    ids = @db.execute "SELECT Id FROM Station ORDER BY Id"
    stationInfo = @db.execute "SELECT * FROM Station ORDER BY Id"

    i = 0
    for stationID in ids
      if @invalidStation[stationID[0]] != nil
        currentStation = Station.new stationInfo[i][0], stationInfo[i][1], stationInfo[i][4], stationInfo[i][2], stationInfo[i][3]
        if @validStations[stationID[0]] != nil
          for date in @validStations[stationID[0]]
            data = @db.execute "SELECT * FROM #{stationID[0]} WHERE Id = ?", date
            currentStation.add_weather Weather.new data[0][0].to_s, data[0][1].to_s, data[0][2].to_s, data[0][3].to_s
          end
          stationList.push currentStation
        else
          for date in @invalidStation[stationID[0]]
            data = @db.execute "SELECT * FROM #{stationID[0]} WHERE Id = ?", date
            currentStation.add_weather Weather.new data[0][0].to_s, data[0][1].to_s, data[0][2].to_s, data[0][3].to_s
          end
          badStationList.push currentStation
        end
      end

      i += 1
    end

    # for sta in stationList
    #   puts sta.code
    #   for shit in sta.weather
    #     if sta.code == 'USW00093227' or sta.code == 'USW00023272'
    #       puts shit.date.to_s + ' has max temp ' + shit.t_max.to_s + ' has min temp ' + shit.t_min.to_s
    #     end
    #   end
    #   puts '-----------------------------------------------'
    # end

    # puts stationList.length
    # puts badStationList.length
    return stationList, badStationList
  end

  def self.daysBetween startYear, period
    days = 0
    i = 0
    for i in 0..period
      if startYear%4 == 0
        if startYear%100 == 0
          if startYear%400 == 0
            days+=1
          end
        end
      end
      days+=365
      startYear+=1
    end
    return days.to_i
  end

  def self.editTable
    stm = @db.execute "Select Id FROM Station WHERE Id like 'USW00093117'"
    # print stm
    for i in stm
      puts i[0]
      @db.execute "DROP TABLE #{i[0]}"
      @db.execute "DELETE FROM Station WHERE Id=?",i[0]
    end
  end
end
SQL.editTable