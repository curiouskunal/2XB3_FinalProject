require 'minitest/autorun'
require '../weather.rb'

class WeatherTest < Minitest::Test
  def test_constructor
    weather = Weather.new '20140101', '10', '217', '83'
    assert_equal Date.new(2014, 1, 1), weather.date
    assert_equal 10, weather.precipitation
    assert_equal (8.3..21.7), weather.temp
    assert_equal 21.7, weather.t_max
    assert_equal 8.3, weather.t_min
  end
end