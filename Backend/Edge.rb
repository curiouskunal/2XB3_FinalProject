require './station'
require 'set'
#Edge takes in two stations and tolerance and will calculate
#the percent days in tolerance for rain and temperature aswell
#as calculate the length of the edge
class Edge

  def initialize(node1, node2, tolerance)
    @s1=node1
    @s2=node2
    #pre-calculate all values
    # @tempDays = PercentTempDays(@s1.weather,@s2.weather,tolerance)
    # @rainDays = PercentRainDays(@s1.weather,@s2.weather,tolerance)
    @length = distanceCalc(@s1,@s2)
  end

  def PercenTemptDays(val1, val2, tolerance)
    tmpVals=0.0;
    for i in 0..(val1.length-1)
      if (withinTolerance(val1[i].t_max, val2[i].t_max, tolerance) && withinTolerance(val1[i].t_min, val2[i].t_min, tolerance))
        tmpVals=tmpVals+1
      end
    end
    return tmpVals/val1.length
  end

  def PercentRainDays(val1, val2, tolerance)
    tmpVals=0.0;
    for i in 0..(val1.length-1)
      if (withinTolerance(val1[i].precipitation, val2[i].precipitation, tolerance))
        tmpVals=tmpVals+1
      end
    end
    return tmpVals/val1.length
  end

  def withinTolerance(val1, val2, tolerance)
    if (val1>val2)
      return (val1-val2)<=tolerance
    end
    return (val2-val1)<=tolerance
  end

  def nodes()
    return @s1, @s2
  end

  def getWeather()
    return @tempDays, @rainDays
  end

  def distanceCalc(s1, s2)
    radiusEarth=6371000;
    x1 = s1.location.longitude*(Math::PI/180.0)
    x2 = s2.location.longitude*(Math::PI/180.0)
    y1 = s1.location.latitude*(Math::PI/180.0)
    y2 = s2.location.latitude*(Math::PI/180.0)
    deltaX = x1-x2
    deltaY=y1-y2
    a = Math.sin(deltaX/2.0) * Math.sin(deltaX/2.0) + Math.cos(x1) * Math.cos(x2) * Math.sin(deltaY/2.0)* Math.sin(deltaY/2.0)
    circumfrence = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0-a))

    return radiusEarth * circumfrence
  end

  def self.distanceCalc(s1, s2)
    radiusEarth=6371000;
    x1 = s1.location.longitude*(Math::PI/180.0)
    x2 = s2.location.longitude*(Math::PI/180.0)
    y1 = s1.location.latitude*(Math::PI/180.0)
    y2 = s2.location.latitude*(Math::PI/180.0)
    deltaX = x1-x2
    deltaY=y1-y2
    a = Math.sin(deltaX/2.0) * Math.sin(deltaX/2.0) + Math.cos(x1) * Math.cos(x2) * Math.sin(deltaY/2.0)* Math.sin(deltaY/2.0)
    circumfrence = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1.0-a))

    return radiusEarth * circumfrence
  end

  def distance()
    return @length
  end

  def >= (other)
    return @length>=other.distance()
  end


  def self.cross(vals1, vals2)
    if (vals2==nil)
      return checkPoints(@s1, @s2, vals1.s1, vals1.s2)
    end
    return true;
  end

  def cross(other)
    if other.is_a? Edge
      #Other
      a, b = other.nodes
      x1, y1, x2, y2 = a.lon, a.lat, b.lon, b.lat
      if x2 - x1 == 0
        puts 'x2o == x1o, ' + x2.to_s + ', ' + x1.to_s
      end
      mo = (y2 - y1)/(x2 - x1)
      bo = y1 - mo * x1


      # Self
      a, b = self.nodes
      x1, y1, x2, y2 = a.lon, a.lat, b.lon, b.lat
      if x2 - x1 == 0
        puts 'x2s == x1s, '  + x2.to_s + ', ' + x1.to_s
      end
      ms = (y2 - y1)/(x2 - x1)
      bs = y1 - ms * x1

      #Equation
      if ms - mo == 0
        puts 'ms == mo, ' + ms.to_s + ', ' + mo.to_s
      end
      x = (bo - bs) / (ms - mo)
      y = ms * x + bs

      #Cross?
      if a.lon > b.lon
        x_max, x_min = a.lon, b.lon
      else
        x_max, x_min = b.lon, a.lon
      end

      if a.lat > b.lat
        y_max, y_min = a.lat, b.lon
      else
        y_max, y_min = b.lat, a.lon
      end

      t = 0
      if (x < x_max - t) and (x > x_min + t) and (y < y_max - t) and (y > y_min + t)
        return true
      else
        return false
      end
    else
      other.each do |e|
        if self.cross e
          return true
        end
      end
      return false
    end
  end

  def reverse
    Edge.new @s2, @s1, 0
  end

  def eql? other
    self.class == other.class && self.state == other.state
  end

  def hash
    @s1.hash + @s2.hash
  end


  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end

  def to_s
    @s1.location.latitude.to_s + "," + @s1.location.longitude.to_s + "," + @s2.location.latitude.to_s  + "," + @s2.location.longitude.to_s
  end
end


# tmp = Edge.new(Station.new(1, 1, 1, 0, 0), Station.new(1, 1, 1, 10, 10), 0)
# tmp2 = Edge.new(Station.new(1, 1, 1, 10, 0), Station.new(1, 1, 1, 0, 0), 0)
# tmp3 = Edge.new(Station.new(1, 1, 1, 5, 0), Station.new(1, 1, 1, 0, 0), 0)
# hi = Set.new()
# hi.add(tmp2)
# hi.add(tmp3)
# print tmp.cross(Set.new())
# print tmp.cross(hi)
# puts "over"

# e1 = Edge.new((Station.new 0, 0, 0, 38.28, -119.61), (Station.new 0, 0, 0, 36.9111,-119.305), 0)
# e2 = Edge.new((Station.new 0, 0, 0, 38.07,-119.23), (Station.new 0, 0, 0, 37.25028,-119.70528), 0)
# puts e1.cross e2
