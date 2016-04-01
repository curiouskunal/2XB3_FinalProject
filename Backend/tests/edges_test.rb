require 'minitest/autorun'
require './Edge'
require './node'
class TestMeme < Minitest::Unit::TestCase
    def setup
      @edge = Edge.new(Station.new([2,7,-16,0],[2,4,6,8],43.7,79.4),Station.new([0,0,0,0],[10,8,6,4],49.2827,123.1207));
    end

    def test_t1
      assert_equal false, @edge.withinTolerance(2,-3,3)
    end

    def test_t2
      assert_equal true, @edge.withinTolerance(2,-4,10)
    end

    def test_t3
      assert_equal 0.50, @edge.PercentDays([2,7,-16,0],[0,0,0,0],6.5)
    end

    def test_t4
      assert_equal false, @edge.withinTolerance(2,3,0.5)
    end

    def test_t5
      assert_equal true, @edge.withinTolerance(2,3,1)
    end

    def test_t6
      assert_equal 0.75, @edge.PercentDays([2,4,6,8],[10,8,6,4],6)
    end

    def test_t7
     assert_equal [0.5,0.75] , @edge.calculateWeather([2,7,-16,0],[2,4,6,8],[0,0,0,0],[10,8,6,4],6.5,6)
    end

    def test_t8
      assert_equal [0.5,0.75] , @edge.getWeather()
    end

    def test_t9
      assert_in_delta 3355000, @edge.distance(), 500
    end

end