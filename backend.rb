require './Edge'
require './FilteringCSV'
require './parse_sort'
require './station'
require './weather'
class BackEnd
  @fullStationList = Array.new
  @searchGrid
  @edgeList = Array.new
  #extracted from pareek's code
  def self.parse (dataFile)
    inputCSV = 'data/'+dataFile

    currentStation = Station.new "0", "0", "0", "0", "0"
    roundOne=true;

    CSV.foreach(inputCSV, headers:true) do |row|
      # puts row
      tmp = row[0].to_s
      if currentStation.code != tmp
        #so that the 0th element is not blank
        if !roundOne
          @fullStationList.push(currentStation)
        else
          roundOne=false;
        end
        currentStation = Station.new row[0], row[1], row[2], row[3], row[4]
      end
      currentStation.add_weather (Weather.new row[5], row[6], row[7], row[8])
    end
  end

  def self.createGrid
    topLeftLong, topLeftLat = -125, 42
    bottomRightLong, bottomRightLat = -114, 32
    #delte original to free up memorey
    #1 degree grid size
    @searchGrid = Array.new(topLeftLat,bottomRightLat) {Array.new(bottomRightLong-topLeftLong) {Array.new}}
    for i in 0..(@fullStationList.length-1)
      tmp = @fullStationList[i]
      @searchGrid[(tmp.location.latitude-bottomRightLat).floor][(tmp.location.longitude-topLeftLong).floor].push('hi')
    end
  end

  def self.run
    dataFile = 'Test.csv'

    x = FilteringCSV.new
    x.filterCSVdata('data/california.csv','data/'+dataFile,730)

    parse (dataFile)
    createGrid()

    puts 'hi'
  end
end


BackEnd.run
