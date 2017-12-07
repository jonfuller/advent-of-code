require 'pp'

def debug(str)
  pp str
end

def odds
  (0..Float::INFINITY).lazy.reject{|i| i%2 == 0}
end

def ring_ranges
  (2..Float::INFINITY).lazy.zip(odds).lazy.zip(odds.drop(1))
    .map{|x| x.flatten}
    .map{|x| {ring: x[0], width: x[2], beginning: x[1]*x[1]+1, next_beginning: x[2]*x[2]+1}}
    .lazy
end

def rings(input)
  rings = ring_ranges
    .map{|r| r.merge({items: (r[:beginning]..r[:next_beginning]-1).to_a})}
    .map{|r| r.merge({length: r[:items].length})}
    .take_while{|r| r[:beginning] < input}
    .to_a

  [{ring: 1, width: 1, beginning: 1, next_beginning: 2, items: [1], length: 1}] + rings
end

def get_coords(ring)
  items = ring[:items].map{|num| {num: num}}

  offsets = (-ring[:width]/2+1...ring[:width]/2+1).to_a

  # right side coords
  items
    .rotate(-1)
    .take(ring[:width])
    .each_with_index do |item, i|
      item[:x] = ring[:width]/2;
      item[:y] = offsets[i];
    end

  # top coords
  items
    .rotate(-1)
    .drop(ring[:width] - 1) # discard right side (but not the corner)
    .take(ring[:width]) # only work on top side
    .each_with_index do |item, i|
      item[:x] = -offsets[i]
      item[:y] = ring[:width]/2
    end
  
  # left coords
  items
    .rotate(-1)
    .drop(ring[:width] - 1) # discard right side (but not the corner)
    .drop(ring[:width] - 1) # discard top side (but not the corner)
    .take(ring[:width]) # only work on left side
    .each_with_index do |item, i|
      item[:x] = -ring[:width]/2 + 1;
      item[:y] = -offsets[i];
    end
  
  # bottom coords
  items
    .rotate(-1)
    .drop(ring[:width] - 1) # discard right side (but not the corner)
    .drop(ring[:width] - 1) # discard top side (but not the corner)
    .drop(ring[:width] - 1) # discard left side (but not the corner)
    .take(ring[:width]) # only work on bottom side
    .each_with_index do |item, i|
      item[:x] = offsets[i];
      item[:y] = -ring[:width]/2 + 1;
    end
  
  items.each do |item|
    item[:x] = item[:x]
    item[:y] = item[:y]
  end
end

def transport_length(input)
  items = get_coords(rings(input).last)

  item = items.find{|i| i[:num] == input}
  item[:x].abs + item[:y].abs
end

pp transport_length(1)
pp transport_length(12)
pp transport_length(23)
pp transport_length(1024)
pp transport_length(289326)