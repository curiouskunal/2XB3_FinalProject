def main
  file = File.open "sample.txt", "r"
  fullList = Array.new
  while !file.eof?
    fullList << file.readline
  end
  puts fullList
  sort fullList, fullList.size
  print " \n"
  puts fullList
end

def sort list, size
  list.class == Array
  size = size - 1
  size.downto(0) do |i|
    heapify list,i,size
  end

  size.downto(1) do |i|
    list[0], list[i] = list[i], list[0]
    size = size - 1
    heapify list,0,size
  end
end

def heapify x, i, n
  x.class == Array
  left = i * 2
  right = left + 1
  j = i

  if (left <=n && x[left].to_i > x[j].to_i)
    j = left
  end
  if (right <= n && x[right].to_i > x[j].to_i)
    j = right
  end

  if (j != i)
    x[i], x[j] = x[j], x[i]
    heapify x,j,n
  end
end

main