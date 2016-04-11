=begin
  Weather station ADT
=end
class Station
=begin
  Constructor for weather Station ADT
  Inputs:
    code: station ID string
    name: station Name string
    elev: station elevation int
    lat: station latitude float
    lon: station longintude float
=end
  def initialize code, name, elev, lat, lon
    @location = Location.new lat.to_f, lon.to_f
    @elevation = elev.to_i
    @code = code.to_s
    @name = name.to_s
    @number_of_connections = 0
    @weather = []
  end
=begin
  returns location
=end
  def location
    @location
  end
=begin
  returns latitude
=end
  def lat
    @location.latitude
  end
=begin
  returns longitude
=end
  def lon
    @location.longitude
  end
=begin
  returns elevation
=end
  def elevation
    @elevation
  end
=begin
  returns station ID
=end
  def code
    @code
  end
=begin
  returns station name
=end
  def name
    @name
  end
=begin
  increments the number of connections to the station
=end
  def inc_connections
    @number_of_connections += 1
  end
=begin
  decrements the number of connections to the station
=end
  def dec_connections
    @number_of_connections -= 1
  end
=begin
  returns the number of connections to the station
=end
  def connections
    @number_of_connections
  end
=begin
  adds a weather day to the station
  day: Weather day
=end
  def add_weather day
    @weather.push day
  end
=begin
  returns all the weather days in the station
=end
  def weather
    @weather
  end
=begin
  Converts station to string
=end
  def to_s
    s = "{\n" +
        "\tID: #{@code.to_s},\n" +
        "\tName: #{@name.to_s},\n" +
        "\tElevation: #{@elevation.to_s},\n" +
        "\tLocation: #{@location.to_s},\n" +
        "\tNumber of Connections: #{@number_of_connections},\n" +
        "\tDays: " #{@weather}\n" +
        #"}"

    l = @weather.size
    if l > 0
      ws = "[\n"
      @weather.each_with_index { |w, i|
        ws << "\t\t#{w.to_s}"
        if i < (l - 1)
          ws << ","
        end
        ws << "\n"
      }
      ws << "\t]\n"
    else
      ws = "[]\n"
    end

    s << ws + "}"
    s
  end
=begin
  equality operator
=end
  def == other
    self.class == other.class && self.state == other.state
  end
=begin
  hash code
=end
  def hash
    code.hash
  end
=begin
  returns state
=end
  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end
end

=begin
  Location ADT
=end
class Location
  attr_reader :latitude
  attr_reader :longitude
=begin
  Constructor for Location ADT
=end
  def initialize latitude, longitude
    @latitude = latitude.to_f
    @longitude = longitude.to_f
  end
=begin
  equality operator
=end
  def == other
    self.class == other.class && self.state == other.state
  end
=begin
  Converts to string
=end
  def to_s
    if @latitude >= 0
      latitude = @latitude.to_s + " N"
    else
      latitude = @latitude.abs.to_s + " S"
    end
    if @longitude >= 0
      longitude = @longitude.to_s + " E"
    else
      longitude = @longitude.abs.to_s + " W"
    end
    "( " + latitude + ", " + longitude + " )"
  end
=begin
  returns state
=end
  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end
end