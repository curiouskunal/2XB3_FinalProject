require './station'
require './weather'
require './Edge'
require './minPQEdges'
require 'set'
=begin
	BackEnd ADT
=end
class BackEnd
=begin
	Instance variables
=end
  @searchGrid
  @visited = Set.new
  @graphNodes = Set.new
  @graphEdges = Set.new
  @possibleEdges = MinPQEdges.new
  @fullStationList = Array.new

  def self.resetVals
    @searchGrid
    @visited = Set.new
    @graphNodes = Set.new
    @graphEdges = Set.new
    @possibleEdges = MinPQEdges.new
    @fullStationList = Array.new
  end
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
=begin
	data: Set.new
	Assigns data to @fullStationList
=end
  def self.setData(data)
      @fullStationList=data;
  end
=begin
	Returns @fullStationList
=end
  def self.getData()
    return @fullStationList
  end
=begin
	Creates the @searchGrid
=end
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
=begin
	Creates edges
=end
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
=begin
	Trims edges that cross or are not related
=end
  def self.trimEdges
    self.createMST
    until @possibleEdges.empty?
      edge = @possibleEdges.pop
      unless edge.cross @graphEdges or !edge.is_related?
        unless @graphEdges.include? edge or @graphEdges.include? edge.reverse
          @graphEdges.add edge
          a, b = edge.nodes
          unless @graphNodes.include? a
            @graphNodes.add a
          end
          unless @graphNodes.include? b
            @graphNodes.add b
          end
        end
      end
    end
  end
=begin
	Makes edges
	curr: current Station
	nodes: Set of Stations
	returns: Set of Edges between curr and eachother nodes
=end
  def self.makeEdges curr, nodes
    edges = Set.new
    nodes.each do |node|
      edges.add (Edge.new curr, node)
      # puts '-----------------------------'
      # puts curr.code
      # puts curr.weather.length
      # puts node.code
      # puts node.weather.length

    end
    edges
  end
=begin
	Returns nodes adjacent to node
	node: weather Station
	x, y: int x and y coordinates of node in @searchGrid
	returns: Set of Stations
=end
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
=begin
	Check related
	returns: Hash[Station.code:String, Array of Stations it predicts including itself]
=end
  def self.checkRelated
    graph = Hash.new
    @graphNodes.each do |node|
      graph[node.code] = Array.new
      graph[node.code].push node
    end
    @graphEdges.each do |edge|
      a, b = edge.nodes
      if graph[a.code] == nil
        next
      end
      if graph[b.code] == nil
        next
      end
      if graph[a.code].length == 1
        if Edge.is_related? a, b
          graph[b.code].push graph[a.code][0]
          graph.delete a.code
        end
      elsif graph[b.code].length == 1
        if Edge.is_related? a, b
          graph[a.code].push graph[b.code][0]
          graph.delete b.code
        end
      end
    end
    graph
  end
=begin
	Returns @graphEdges
=end
  def self.getEdges()
    return @graphEdges
  end
=begin
	creates Minimum Spanning Tree
=end
  def self.createMST
    visited = Set.new
    edges = MinPQEdges.new
    mst = Set.new
    @graphEdges.each do |edge|
      edges.add edge
    end
    until edges.empty?
      edge = edges.pop
      a, b = edges.nodes
      if visited.include? a and not visited.include? b
        visited.add b
        mst.add edge
      elsif visited.include? b and not visited.include? a
        visited.add a
        mst.add edge
      elsif not visited.include? a and not visited.include? b
        visited.add a
        visited.add b
        mst.add edge
      end
    end
    @graphEdges = mst
  end
=begin
	Runs the backend
=end
  def self.run
    dataFile = 'test3.csv'
    parse (dataFile)
    createGrid()
    puts 'Finished Parsing'
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