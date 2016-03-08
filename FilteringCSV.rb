class FilteringCSV
  require 'csv'

=begin

-String inputCSV is input CSV file name or location
-String outputCSV is output CSV file name or location

-format of inputCSV:
STATION,STATION_NAME,ELEVATION,LATITUDE,LONGITUDE,DATE,PRCP,TSUN,TMAX,TMIN

* Omitting TSUN data. *

=end

  def parceCSVdata(inputCSV, outputCSV)

    CheckRows(inputCSV,'temp/tempCSV1.csv',true)

  end



  # method to check weather or not row has all data
  def isPrintLine(row)
    # loops through all values in row to check if data is missing.
    # missing data is indicated by "-9999"
    for i in 0..6
      if -9999 == row[i].to_i
        # print " bad "
        return false
      else
        # print "good "
        # saveLine will remain true.
      end
    end
    for i in 8..9
      if -9999 == row[i].to_i
        # print " bad "
        return false
      else
        # print "good "
        # saveLine will remain true.
      end
    end
    return true
  end

  # Method checks each row in inputCSV for completeness then saves all good rows to
  # outputCSV, keepHeader:
  def CheckRows(inputCSV,outputCSV,keepHeader)

    # row counter
    index = 0

    # open inputCSV file and iterate row by row
    CSV.foreach(inputCSV, headers:(!keepHeader)) do |row|

      # by default we want to save row unless changed
      saveLine = true

      #isPrintLine returns bool. true = stores whether or not the line will be printed
      saveLine = isPrintLine(row)

      # increment row number
      index += 1

      # if saveline is true. Then save row to output CSV file
      if saveLine
        open(outputCSV, 'a') { |f| f.puts row.to_s}
      end

    end

    # TODO - delete this, dont want to print this @ EOF.
    open(outputCSV, 'a') { |f| f.puts "----------------------------------"}
  end


  #TODO - make funciton to check if stations are compleet
  # def checkStations(inputCSV,outputCSV,keepHeader)
  #   CSV.foreach(inputCSV, headers:(!keepHeader)) do |row|
  #
  #   end
  # end

end





# --- MAIN ---

x = FilteringCSV.new
x.parceCSVdata('data/Testing.csv','data/caliFinal.csv')
