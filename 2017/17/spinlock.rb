require 'pp'

def debug(state, position)
  line = state.each_with_index.map{|v, i| i == position ? "(#{v})" : "#{v}"}.map{|v| v.center(3)}.join(" ")
  puts "#{position} - #{line}"
end

def insert(array, location, value)
  array.insert(location, value)
end

def insert_fake(array, location, value)
  array.unshift(0) # <-- a fast way to prepend to the front of a ruby array
end

def spin(steps, state, current_position, iterations, search_value)
  answer = -1
  (1..iterations).each do |i|
    insert_location = ((current_position + steps) % state.length)+1
    state = insert(state, insert_location, i)

    current_position = insert_location
  end
  the_index = state.find_index{|v| v == search_value} + 1
  state[the_index]
end

def spin2(steps, state, current_position, iterations)
  answer = -1
  (1..iterations).each do |i|
    insert_location = ((current_position + steps) % state.length)+1
    # takes advantage of knowing that 0 is ALWAYS at index zero.
    # so whenever the insert location is 1, we know that's the next
    # possible answer.
    answer = i if (insert_location == 1)
    state = insert_fake(state, insert_location, i)

    current_position = insert_location
  end
  answer
end

pp spin(3, [0], 0, 10, 10)
pp spin(324, [0], 0, 2017, 2017)

pp spin2(324, [0], 0, 50_000_000, 0)