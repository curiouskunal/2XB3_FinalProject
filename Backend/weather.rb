require 'date'

class Weather

  def initialize date, precipitation, t_max, t_min
    @date = Date.new(
        date.byteslice(0..3).to_i,
        date.byteslice(4..5).to_i,
        date.byteslice(6..7).to_i
    )
    @precipitation = precipitation.to_i
    @temp = ((t_min.to_f/10)..(t_max.to_f/10))
  end

  def date
    @date
  end
  def temp
    @temp
  end
  def t_max
    @temp.max
  end
  def t_min
    @temp.min
  end
  def precipitation
    @precipitation
  end

  def to_s
    "[ Date: " + @date.to_s + ", Precipitation: " + @precipitation.to_s + ",  Temperature: " + @temp.to_s + " ]"
  end

  def == other
    self.class == other.class && self.state == other.state
  end

  def state
    self.instance_variables.map { |variable| self.instance_variable_get variable }
  end

end