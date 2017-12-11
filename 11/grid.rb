require 'pp'

def input
  File.read('input').split(',')
end

def samples
  [
    {input: "ne,ne,ne".split(','), answer: 3},
    {input: "ne,ne,sw,sw".split(','), answer: 0},
    {input: "ne,ne,s,s".split(','), answer: 2},
    {input: "se,sw,se,sw,sw".split(','), answer: 3},
  ]
end

def move(current, direction)
  delta = case direction
  when "n"
    {x: 0, y: 1, z: -1}
  when "ne"
    {x: 1, y: 0, z: -1}
  when "se"
    {x: 1, y: -1, z: 0}
  when "s"
    {x: 0, y: -1, z: 1}
  when "sw"
    {x: -1, y: 0, z: 1}
  when "nw"
    {x: -1, y: 1, z: 0}
  end
  {
    x: current[:x] + delta[:x],
    y: current[:y] + delta[:y],
    z: current[:z] + delta[:z],
  }
end

def count_steps(input)
  starting = {x: 0, y: 0, z: 0}
  ending = input.inject(starting){|current, step| move(current, step)}

  [:x, :y, :z].inject(0){|sum, sym| sum + (ending[sym] - starting[sym]).abs}/2
end

# samples.each do |sample|
#   pp sample[:input], count_steps(sample[:input]), sample[:answer]
# end

pp count_steps(input)