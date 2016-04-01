class Station


  def initialize code, name, elev, lat, lon
    @location = Location.new lat.to_f, lon.to_f
    @elevation = elev.to_i
    @code = code.to_s
    @name = name.to_s
    @number_of_connections = 0
    @weather = []
  end

  def location
    @location
  end

  def elevation
    @elevation
  end

  def code
    @code
  end

  def name
    @name
  end

  def inc_connections
    @number_of_connections += 1
  end

  def dec_connections
    @number_of_connections -= 1
  end

  def connections
    @number_of_connections
  end

  def add_weather day
    @weather.push day
  end

  def weather
    @weather
  end

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

end

class Location
  attr_reader :latitude
  attr_reader :longitude

  def initialize latitude, longitude
    @latitude = latitude.to_f
    @longitude = longitude.to_f
  end

  def == other
    self.class == other.class && self.state == other.state
  end

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

  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end
end