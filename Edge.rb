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
    #@tempDays = PercentTempDays(@s1.weather,@s2.weather,tolerance)
    #@rainDays = PercentRainDays(@s1.weather,@s2.weather,tolerance)
    #@length = distanceCalc(@s1,@s2)
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

  def getNodes()
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

  def cross(vals1)
    if (vals1.is_a?(Set))
      puts "sup"
      return false
    end
    if vals1.is_a?(Edge)
      tmp1, tmp2=vals1.getNodes()
      return Edge.checkPoints(@s1, @s2, tmp1, tmp2)
    else
      puts vals1
      if (vals1.empty?)
        return false
      elsif (!vals1.empty?)
        doesCross=false
        vals1.each do |tmp|
          tmp1, tmp2=tmp.getNodes()
          if (!doesCross)
            doesCross = Edge.checkPoints(@s1, @s2, tmp1, tmp2)
          end
        end
        return doesCross
      else
        return false
      end
    end
  end

  def self.checkPoints(s1, s2, s3, s4)
    x1=s1.location.latitude*(Math::PI/180.0)
    x2=s2.location.latitude*(Math::PI/180.0)
    x3=s3.location.latitude*(Math::PI/180.0)
    x4=s4.location.latitude*(Math::PI/180.0)
    y1=s1.location.longitude*(Math::PI/180.0)
    y2=s2.location.longitude*(Math::PI/180.0)
    y3=s3.location.longitude*(Math::PI/180.0)
    y4=s4.location.longitude*(Math::PI/180.0)

    px=(((x1*y1-y1*x2)*(x3-x4))-((x1-x2)*(x3*y4-y3*x4)))/(((x1-x2)*(y3-y4))-(y1-y2)*(x3-x4))
    py=(((x1*y2-y1*x2)*(y3-y4))-((y1-y2)*(x3*y4-y3*x4)))/(((x1-x2)*(y3-y4))-((y1-y2)*(x3-x4)))

    det = ((x1-x2)*(y3-y4))-((y1-y2)*(x3-x4))
    if (det ==0)
      return false;
    else
      if (((x1<=px&&px<=x2)||(x2<=px&&px<=x1))&&((x3<=px&&px<=x4)||(x4<=px&&px<=x3)))
        if (((y1<=py&&py<=y2)||(y2<=py&&py<=y1))&&((y3<=py&&py<=y4)||(y4<=py&&py<=y3)))
          return true
        end
      end
      return false
    end
  end
end

tmp = Edge.new(Station.new(1, 1, 1, 0, 0), Station.new(1, 1, 1, 10, 10), 0)
tmp2 = Edge.new(Station.new(1, 1, 1, 10, 0), Station.new(1, 1, 1, 0, 0), 0)
tmp3 = Edge.new(Station.new(1, 1, 1, 5, 0), Station.new(1, 1, 1, 0, 0), 0)
hi = Set.new()
hi.add(tmp2)
hi.add(tmp3)
print tmp.cross(Set.new())
print tmp.cross(hi)
puts "over"