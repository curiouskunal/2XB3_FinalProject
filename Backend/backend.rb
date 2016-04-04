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
          ((tmp.location.latitude-southLat).floor > @searchGrid.length) or
          ((tmp.location.longitude-westLong).floor < 0) or
          ((tmp.location.longitude-westLong).floor > @searchGrid[0].length)
        @searchGrid[(tmp.location.latitude-southLat-1).floor][(tmp.location.longitude-westLong-1).floor].push(tmp)
      end
    end
  end

  def self.createEdges
    @searchGrid.each_with_index do | row, _y|
      row.each_with_index do | box, _x|
        if box.any?
          box.each do | n |
            unless @visited.include? n
              @possibleEdges.push ( self.makeEdges n, (self.adjacent n, _x, _y))
            end
          end
        end
      end
    end
  end

  def self.trimEdges
    until @possibleEdges.empty?
      edge = @possibleEdges.pop
      unless false #edge.cross @graphEdges
        unless @graphEdges.include? edge or @graphEdges.include? edge.reverse
          @graphEdges.add edge
        end
      end
    end
  end

  # def self.graph node=nil, x=nil, y=nil
  #   if node == nil
  #     @searchGrid.each_with_index do | row, _y|
  #       row.each_with_index do | box, _x|
  #         if box.any?
  #           box.each do | n |
  #             unless @visited.include? n
  #               self.graph n, _x, _y
  #             end
  #           end
  #         end
  #       end
  #     end
  #   else
  #     curr = node
  #     @possibleEdges.push ( self.makeEdges curr, (self.adjacent curr, x, y))
  #     @visited.add curr
  #     until @possibleEdges.empty?
  #       edge = @possibleEdges.pop
  #       unless edge.cross @graphEdges
  #         unless @graphEdges.include? edge or @graphEdges.include? edge.reverse
  #           @graphEdges.add edge
  #         else
  #           next
  #         end
  #         a, b = edge.nodes
  #         unless @graphNodes.include? a
  #           @graphNodes.add a
  #           @count += 1
  #         end
  #         unless @graphNodes.include? b
  #           @graphNodes.add b
  #         end
  #         curr = unless @graphNodes.include? b
  #                  b
  #                else
  #                  a
  #                end
  #         @visited.add curr
  #
  #         ( self.makeEdges curr, (self.adjacent curr, x, y)).each do |e|
  #           unless @graphEdges.include? e or @graphEdges.include? e.reverse
  #             @possibleEdges.push e
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

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
      if (_x >= 0) and (_x < @searchGrid[0].length)
        ys.each do |_y|
          if (_y >= 0) and (_y < @searchGrid.length)
            @searchGrid[_y][_x].each do |n|
              adj.add n
            end
          end
        end
      end
    end
    adj.each do |n|
      unless (not node == n) and ((Edge.distanceCalc node, n ) <  50000)
        adj.delete n
      end
    end
    adj
  end

  def self.run
    dataFile = 'test3.csv'
    parse (dataFile)
    # (-123..-112).each do |y|
    #   (32..42).each do |x|
    #     @fullStationList.push (Station.new 0, 0, 0, x,y)
    #
    #   end
    # end
    createGrid()

    # puts @searchGrid.to_s

    puts 'Finished Parsing'
    # graph()
    createEdges
    puts 'Created Edges'
    trimEdges
    puts 'Finished Graphing'
    File.open 'edges.txt', 'w' do |file|
      @graphEdges.each do |edge|
        file.write (edge.to_s + "\n")
      end
    end
    puts 'done'
  end
end

BackEnd.run