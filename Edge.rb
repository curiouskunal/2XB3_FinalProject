require './station'
#Edge takes in two stations and tolerance and will calculate
#the percent days in tolerance for rain and temperature aswell
#as calculate the length of the edge
class Edge

  def initialize(node1, node2, tolerance)
    @s1=node1
    @s2=node2
    #pre-calculate all values
    @tempDays = PercentTempDays(@s1.weather,@s2.weather,tolerance)
    @rainDays = PercentRainDays(@s1.weather,@s2.weather,tolerance)
    @length = distanceCalc(@s1,@s2)
  end

  def PercenTemptDays(val1,val2,tolerance)
    tmpVals=0.0;
    for i in 0..(val1.length-1)
      if(withinTolerance(val1[i].t_max,val2[i].t_max,tolerance) && withinTolerance(val1[i].t_min,val2[i].t_min,tolerance))
        tmpVals=tmpVals+1
      end
    end
    return tmpVals/val1.length
  end

  def PercentRainDays(val1,val2,tolerance)
    tmpVals=0.0;
    for i in 0..(val1.length-1)
      if(withinTolerance(val1[i].precipitation,val2[i].precipitation,tolerance))
        tmpVals=tmpVals+1
      end
    end
    return tmpVals/val1.length
  end

  def withinTolerance(val1,val2,tolerance)
    if (val1>val2)
      return (val1-val2)<=tolerance
    end
    return (val2-val1)<=tolerance
  end

  def getWeather()
    return @tempDays, @rainDays
  end

  def distanceCalc(s1, s2)
    radiusEarth=6371000;
    x1 = @s1.location.longitude*(Math::PI/180.0)
    x2 = @s2.location.longitude*(Math::PI/180.0)
    y1 = @s1.location.latitude*(Math::PI/180.0)
    y2 = @s2.location.latitude*(Math::PI/180.0)
    deltaX = x1-x2
    deltaY=y1-y2
    a = Math.sin(deltaX/2.0) * Math.sin(deltaX/2.0) + Math.cos(x1) * Math.cos(x2) * Math.sin(deltaY/2.0)* Math.sin(deltaY/2.0)
    circumfrence = 2 * Math.atan2(Math.sqrt(a),Math.sqrt(1.0-a))

    return radiusEarth * circumfrence
  end

  def distance()
    return @length
  end

  def >= (other)
    return @length>=other.distance()
  end
end