class MinPQEdges

  def initialize ()
    Array @que = Array.new()  #the que
    Integer @N =0#items in que
  end

  def isEmpty()
    return @que.length == 0
  end

  def insert(e)
    @que.push(e)
    swim(e)
  end

  def swim(Integer pos)
    while ()
  end
end

test = Array.new()
test.push(1)
for i in Range.new(0,5)
  test.push(i)
end
print test
test = MinPQEdges.new()
puts test.isEmpty
test.insert(1)
puts test.isEmpty