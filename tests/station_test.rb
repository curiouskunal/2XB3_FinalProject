require 'minitest/autorun'
require '../station.rb'

class StationTest < Minitest::Test
  def test_constructor
    station = Station.new 'GHCND:USR0000CTHO',
                          'THOMES CREEK CALIFORNIA CA US',
                          '150', '10', '-20'
    assert_equal 150, station.elevation
    assert_equal (Location.new 10, -20), station.location
    assert_equal 'GHCND:USR0000CTHO', station.code
    assert_equal 'THOMES CREEK CALIFORNIA CA US',
                 station.name
  end
end

class LocationTest < Minitest::Test
  def setup
    @loc = Location.new 10, -20
  end

  def test_constructor
    assert_equal @loc.latitude, 10
    assert_equal @loc.longitude, -20
  end

  def test_equality
    assert_equal @loc, (Location.new 10, -20)
    refute_equal @loc, (Location.new 15, -20)
    refute_equal @loc, (Location.new 10, 15)
  end
end