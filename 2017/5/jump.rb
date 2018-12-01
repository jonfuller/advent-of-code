require 'rubygems'
require 'pp'

def load_input
  File.read('input').lines.map{|l| l.chomp}.map{|l| l.to_i}
end

def jump(jumps, location)
  jumps[location] + location
end

def print(step, jumps, location)
  puts "#{step.to_s.center(3)} (#{location.to_s.center(3)})  - [#{jumps.map{|j| j.to_s}.each_with_index.map{|j, i| (i==location)? '(' + j + ')' : j}.map{|j| j.center(4)}.join(', ')}]"
end

def increment(value)
  return -1 if value >=3
  1
end

def find_steps
  steps = 0
  jumps = load_input#.take(25)
  location = 0
  while location < jumps.length do #&& steps < 300 do
    #print(steps, jumps, location)
    steps = steps+1
    previous = location
    location = jumps[location] + location
    jumps[previous] = jumps[previous] + increment(jumps[previous])
  end
  steps
end

puts find_steps
