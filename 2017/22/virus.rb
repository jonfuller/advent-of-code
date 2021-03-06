require 'pp'

def debug(*msg)
  #puts *msg
end

def input(filename)
  lines = File.read(filename).lines.map{|l| l.chomp}
  max = lines.count/2
  state = {}
  lines.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      state[{x: x-max, y: y-max}] = char
    end
  end
  state
end

def p_grid(state, current)
  min_x = state.keys.min_by{|k| k[:x]}[:x]
  max_x = state.keys.max_by{|k| k[:x]}[:x]
  min_y = state.keys.min_by{|k| k[:y]}[:y]
  max_y = state.keys.max_by{|k| k[:y]}[:y]

  output = []
  (min_y..max_y).each do |y|
    row = []
    (min_x..max_x).each do |x|
      position = {x: x, y: y}
      state_value = state[position] || Clean
      row << ((position == current) ? "[#{state_value}]" : " #{state_value} ")
    end
    output << row.join(' ')
  end
  output.join("\r\n")
end

Clean = '.'
Infected = '#'
Weakened = 'W'
Flagged = 'F'

North = 0
East = 1
South = 2
West = 3

Directions = {
  North => {x: 0, y: -1},
  East => {x: 1, y: 0},
  South => {x: 0, y: 1},
  West => {x: -1, y: 0}
}

def turn_right(direction)
  (direction + 1) % 4
end

def turn_left(direction)
  (direction - 1) % 4
end

def move(position, direction)
  delta = Directions[direction]

  {x: position[:x] + delta[:x], y: position[:y] + delta[:y]}
end

def condition(state, position)
  (state[position] || Clean)
end

def new_condition(current_condition)
  case current_condition
  when Infected
    Flagged
  when Clean
    Weakened
  when Weakened
    Infected
  when Flagged
    Clean
  end
end

def new_direction(current_condition, current_direction)
  case current_condition
  when Infected
    turn_right(current_direction)
  when Clean
    turn_left(current_direction)
  when Weakened
    current_direction
  when Flagged
    turn_right(turn_right(current_direction))
  end
end

def step(state, position, current_direction)
  new_direction =  new_direction(condition(state, position), current_direction)
  state[position] = new_condition(condition(state, position))
  did_infect = condition(state, position) == Infected
  new_position = move(position, new_direction)

  {state: state, position: new_position, current_direction: new_direction, infected: did_infect}
end

def walk(state, position, current_direction, steps)
  infected_cnt = 0
  result = {state: state, position: position, current_direction: current_direction}
  (0...steps).each do |_|
    puts _ if _%1_000_000 == 0
    #debug p_grid(result[:state], result[:position]), ""
    result = step(result[:state], result[:position], result[:current_direction])
    infected_cnt += 1 if result[:infected]
  end
  #debug p_grid(result[:state], result[:position]), ""
  infected_cnt
end

p walk(input('input'), {x: 0, y: 0}, North, 10_000_000)