require 'rubygems'
require 'pp'
require 'bundler/setup'
require 'rgl/adjacency'
require 'rgl/connected_components'

def asciify(str)
  str.chars.map{|c| c.ord}
end

def hash_round(values, lengths, current_position, skip_size)
  values = values.dup
  lengths.each do |length|
    values = values.rotate(current_position)
    values[0..length-1] = values[0..length-1].reverse if length > 0
    values = values.rotate(-current_position)

    current_position = (current_position + length + skip_size) % values.length
    skip_size += 1
  end
  {values: values, position: current_position, skip_size: skip_size}
end

def hash(input)
  lengths = asciify(input) + [17, 31, 73, 47, 23]

  round = {values: (0..255).to_a, position: 0, skip_size: 0}

  (1..64).to_a.each do |_|
    round = hash_round(round[:values], lengths, round[:position], round[:skip_size])
  end

  round[:values]
    .each_slice(16)
    .map{|slice| slice.inject(0){|memo, obj| memo^obj}}
    .map{|char| char.to_s(16).rjust(2, '0')}
    .join
end

def hash_inputs(input_key)
  (0..127).map{|i| "#{input_key}-#{i}"}
end

def bitmap(input_key)
  hash_inputs(input_key)
    .map{|row| hash(row)}
    .map{|hashed| hashed.chars.map{|c| c.to_i(16).to_s(2).rjust(4, '0')}.join}
    .map{|r| r.chars}
end

def count(bitmap)
  bitmap
    .flatten
    .find_all{|b| b=='1'}
    .length
end

def neighbors(bits, x, y)
  [
    bits.find{|b| b[:x] == x+1 && b[:y] == y},
    bits.find{|b| b[:x] == x && b[:y] == y+1},
    bits.find{|b| b[:x] == x-1 && b[:y] == y},
    bits.find{|b| b[:x] == x && b[:y] == y-1}
  ]
  .reject{|n| n.nil?}
end

def graphit(bitmap)
  graph = RGL::AdjacencyGraph.new
  bits = bitmap
    .each_with_index.map{|row, x| row.each_with_index.map{|bit, y| {bit: bit, x: x, y: y, id: "#{x.to_s.rjust(3)},#{y.to_s.rjust(3)}"}}}
    .flatten

  bits
    .find_all{|b| b[:bit] =='1'}
    .each do |bit|
      graph.add_edge(bit[:id], bit[:id])
      neighbors(bits, bit[:x], bit[:y])
        .find_all{|b| b[:bit] == '1'}
        .each do |neighbor|
          graph.add_edge(bit[:id], neighbor[:id])
        end
    end
  graph
end

def groups(graph)
  ccs = []
  graph.each_connected_component { |c| ccs << c }
  ccs
end

sample = 'flqrgnkx'
input = 'hwlqcszp'

sample_bitmap = bitmap(sample)
input_bitmap = bitmap(input)

pp count(sample_bitmap)
pp count(input_bitmap)

pp groups(graphit(sample_bitmap)).length
pp groups(graphit(input_bitmap)).length