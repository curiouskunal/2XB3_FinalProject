require './Edge'
require './FilteringCSV'
require './parse_sort'
require './station'
require './weather'
class BackEnd
  @searchGrid
  @visited = Set.new
  @graphNodes = Set.new
  @graphEdges = Set.new
  @possibleEdges = MinPQ.new


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

  def self.graph node=nil, x=nil, y=nil
    if node == nil
      @searchGrid.each_with_index do | row, _y|
        row.each_with_index do | box, _x|
          if box.any?
            box.each do | n |
              unless @visited.include? n
                self.graph n, _x, _y
              end
            end
          end
        end
      end
    else
      curr = node
      @possibleEdges.push (self.adjacent curr, x, y)
      @visited.add curr
      until @possibleEdges.empty?
        edge = @possibleEdges.pop
        unless edge.cross @graphEdges
          @graphEdges.add edge
          a, b = edge.nodes
          curr = unless @graphNodes.include? b
                   b
                 else
                   a
                 end
          @visited.add curr
          @possibleEdges.push (self.adjacent curr, x, y)
        end
      end
    end
  end

  def self.adjacent node, x, y
    adj = Set.new
    xs = [x-1, x, x+1]
    ys = [y-1, y, y+1]
    xs.each do _x
    if (_x >= 0) and (_x < @searchGrid.length)
      ys.each do _y
      if (_y >= 0) and (_y < @searchGrid[0].length)
        @searchGrid[_x][_y].each do n
        adj.add n
        end
      end
      end
    end
    end

    adj.each do n
      unless (not node == n) and ((distance node, n ) <  100000)
        adj.delete n
      end
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