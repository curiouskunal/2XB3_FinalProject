class Station
  def initialize code, name, elev, lat, lon
    @location = Location.new lat.to_f, lon.to_f
    @elevation = elev.to_i
    @code = code.to_s
    @name = name.to_s
    @number_of_connections = 0
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

  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end
end