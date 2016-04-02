class MinPQEdges

  def initialize ()
    Array @que = Array.new()  #the que
    Integer @size = 0#items in que
  end

  def empty?()
    return @size == 0
  end

  def push(e)
    if e.is_a? Edge
      @size+=1
      @que[@size]=e
      swim(@size)
    else
      e.each do |i|
        self.push i
      end
    end
  end

  def put()
    print @que
  end

  def swim(i)
    while (i > 1 && greater(i/2,i))
      exch(i,i/2)
      i = i/2;
    end
  end

  def sink(i)
    while (2*i <= @size)
      j = 2*i
      if (j<@size && greater(j,j+1))
        j+=1
      end
      if (!greater(i,j))
        break
      end
      exch(i,j)
      i =j
    end
  end

  def greater(i,j)
    # puts @que[i]>@que[j]  , @que[j] , @que[i]
    return @que[i]>=@que[j]
  end

  def size()
    return @size
  end

  def exch(i,j)
    swap =@que[i]
    @que[i] = @que[j]
    @que[j] = swap
  end

  def min()
    if (empty?())
      print "Error: underflow"
    end
    return  @que[1]
  end

  def pop()
    if (empty?())
      print "Error: underflow"
    end
    exch(1,@size)
    # puts @que.class
    min = @que[@size]
    # puts min.class
    @size-=1
    sink(1)
    @que[@size+1]=nil
    #if ((@size > 1) && (@size == (@que.length-1)/4))
    return min;
  end
end