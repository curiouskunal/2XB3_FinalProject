require './station'
require 'set'
#Edge takes in two stations and tolerance and will calculate
#the percent days in tolerance for rain and temperature aswell
#as calculate the length of the edge
class Edge
  @percipTolerance=0;
  @tempTolerance=0;
  @daysAccuracy=0;

  def initialize(node1, node2)
    @s1=node1
    @s2=node2

    #pre-calculate all values
    @canPredict = (Edge.checkTempTolerance(@s1.weather, @s2.weather) or Edge.checkRainTolerance(@s1.weather, @s2.weather))
    @length = Edge.distanceCalc(@s1,@s2)
  end

  def self.setTolerances(rain,temp,days)
    @percipTolerance = rain;
    @tempTolerance = temp;
    @daysAccuracy = days;
  end

  def self.getLength(val1,val2)
    if (val2.length<val1.length)
      return val2.length;
    else
      return val1.length;
    end
  end

  def self.checkTempTolerance(val1, val2)
    tmpVals=0.0;
    leng=Edge.getLength(val1,val2)
    for i in 0..(leng-1)
     # puts i.to_s + ' at ' + val1[i].date.to_s + ' and ' + val2[i].date.to_s
      if (Edge.withinTolerance(val1[i].t_max, val2[i].t_max,   @tempTolerance) && Edge.withinTolerance(val1[i].t_min, val2[i].t_min,   @tempTolerance))
        tmpVals=tmpVals+1
      end
    end
    return (tmpVals+ @daysAccuracy)>=leng
  end

  def self.checkRainTolerance(val1, val2)
    tmpVals=0.0;
    leng=getLength(val1,val2)
    for i in 0..(leng-1)
      if (Edge.withinTolerance(val1[i].precipitation, val2[i].precipitation,  @percipTolerance))
        tmpVals=tmpVals+1
      end
    end
    return (tmpVals+  @daysAccuracy)>=leng
  end

  def self.withinTolerance(val1, val2, tolerance)
    if (!val1 or !val2)
      return false;
    end

    if (val1>val2)
      return (val1-val2)<=tolerance
    end
    return (val2-val1)<=tolerance
  end

  def is_related?()
    return @canPredict
  end

  def self.is_related?(s1,s2)
    return (checkTempTolerance(s1.weather, s2.weather) and checkRainTolerance(s1.weather, s2.weather))
  end

  def nodes()
    return @s1, @s2
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


  def cross(other)
    if other.is_a? Edge
      #Other
      oa, ob = other.nodes
      x1o, y1o, x2o, y2o = oa.lon, oa.lat, ob.lon, ob.lat
      mo = (y2o - y1o)/(x2o - x1o)
      bo = y1o - mo * x1o


      # Self
      sa, sb = self.nodes
      x1s, y1s, x2s, y2s = sa.lon, sa.lat, sb.lon, sb.lat
      ms = (y2s - y1s)/(x2s - x1s)
      bs = y1s - ms * x1s

      #Equation
      x = (bo - bs) / (ms - mo)
      y = ms * x + bs

      #Cross?
      if sa.lon > sb.lon
        x_max, x_min = sa.lon, sb.lon
      else
        x_max, x_min = sb.lon, sa.lon
      end

      if sa.lat > sb.lat
        y_max, y_min = sa.lat, sb.lon
      else
        y_max, y_min = sb.lat, sa.lon
      end

      # t = 1
      if ((x < x_max) and not x.near? x_max) and
          ((x > x_min) and not x.near? x_min) and
          ((y < y_max) and not y.near? y_max) and
          ((y > y_min) and not y.near? y_min)
        return true
      else
        return false
      end
      # if (x < x_max - t) and (x > x_min + t) and (y < y_max - t) and (y > y_min + t)
      #   return true
      # else
      #   return false
      # end
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
    return Edge.new @s2, @s1
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

class Float
  def near? other, epsilon = 1e-6
    (self - other).abs < epsilon.to_f
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
