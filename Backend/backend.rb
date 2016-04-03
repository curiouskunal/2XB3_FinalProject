require './FilteringCSV'
require './parse_sort'
require './station'
require './weather'
require './Edge'
require './minPQEdges'
require 'set'
class BackEnd
  @searchGrid
  @visited = Set.new
  @graphNodes = Set.new
  @graphEdges = Set.new
  @possibleEdges = MinPQEdges.new
  @fullStationList = Array.new


  #extracted from pareek's code
  def self.parse (dataFile)
    inputCSV = 'data/'+dataFile

    currentStation = Station.new "0", "0", "0", "0", "0"
    roundOne=true;

    CSV.foreach(inputCSV, headers:true) do |row|
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
    westLong, northLat = -125, 42
    eastLong, southLat = -114, 32
    #delete original to free up memory
    #1 degree grid size
    @searchGrid = Array.new(northLat-southLat) {Array.new(eastLong-westLong) {Array.new}}
    numStations = @fullStationList.length-1
    for i in 0..numStations
      tmp=@fullStationList.pop();
      unless ((tmp.location.latitude-southLat).floor < 0) or
          ((tmp.location.latitude-southLat).floor >=@searchGrid.length) or
          ((tmp.location.longitude-westLong).floor < 0) or
          ((tmp.location.longitude-westLong).floor > @searchGrid[0].length)
        @searchGrid[(tmp.location.latitude-southLat).floor][(tmp.location.longitude-westLong).floor].push(tmp)
      end
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
      @possibleEdges.push ( self.makeEdges curr, (self.adjacent curr, x, y))
      @visited.add curr
      until @possibleEdges.empty?
        edge = @possibleEdges.pop
        unless edge.cross @graphEdges
          @graphEdges.add edge
          a, b = edge.nodes
          unless @graphNodes.include? a
            @graphNodes.add a
          end
          unless @graphNodes.include? b
            @graphNodes.add b
          end
          curr = unless @graphNodes.include? b
                   b
                 else
                   a
                 end
          @visited.add curr
          print @possibleEdges.size
          puts @possibleEdges.empty?
          ( self.makeEdges curr, (self.adjacent curr, x, y)).each do |e|
            unless @graphEdges.include? e
              @possibleEdges.push e
            end
          end
        end
      end
    end
  end

  def self.makeEdges curr, nodes
    edges = Set.new
    nodes.each do |node|
      edges.add (Edge.new curr, node, 0)
    end
    edges
  end

  def self.adjacent node, x, y
    adj = Set.new
    xs = [x-1, x, x+1]
    ys = [y-1, y, y+1]
    xs.each do |_x|
      if (_x >= 0) and (_x < @searchGrid.length)
        ys.each do |_y|
          if (_y >= 0) and (_y < @searchGrid[0].length)
            @searchGrid[_x][_y].each do |n|
              adj.add n
            end
          end
        end
      end
    end
    # puts adj.length
    adj.each do |n|
      unless (not node == n) and ((Edge.distanceCalc node, n ) <  100000) and (@visited.include? n)
        adj.delete n
      end
    end
    adj
  end

  def self.run
    dataFile = 'test3.csv'
    parse (dataFile)
    createGrid()

    # for y in 0..(@searchGrid.length-1)
    #   # puts y.to_s+" = "
    #   for x in 0..(@searchGrid[0].length-1)
    #     # for i in 0..(@searchGrid[y][x].length-1)
    #     #   puts "    "+@searchGrid[y][x][i].code
    #     # end
    #
    #   end
    # end
    # count = 0
    # @searchGrid.each_with_index do |row, x|
    #   row.each_index do |y|
    #     puts x.to_s + "," + y.to_s + ":" + @searchGrid[x][y].length.to_s
    #     count += @searchGrid[x][y].length
    #   end
    # end
    # puts "total: " + count.to_s
    puts 'Finished Parsing'
    graph()
    puts 'Finished Graphing'
    File.open 'edges.txt', 'w' do |file|
      @graphEdges.each do |edge|
        file.write edge.to_s
      end
    end
    puts 'done'
  end
end

BackEnd.run