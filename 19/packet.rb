require 'pp'

def input(filename)
  File.read(filename)
    .lines
    .map{|l| l.chomp}
    .map{|l| l.chars}
end

def find_move(coord, maze, last_direction)
  value = v(coord, maze)

  case last_direction
  when 'north'
    case value
    when '+'
      value_east = v({x: coord[:x]+1, y: coord[:y]}, maze)
      value_west = v({x: coord[:x]-1, y: coord[:y]}, maze)

      ew = value_east == ' ' ? -1 : 1 # go west (-) if east is blank

      return {x: coord[:x] + (ew * 1), y: coord[:y]}, ew == 1 ? 'east' : 'west'
    else
      puts "BLARG"
      return {x: coord[:x], y: coord[:y]-1}, last_direction
    end
  when 'south'
    case value
    when '+'
      value_east = v({x: coord[:x]+1, y: coord[:y]}, maze)
      value_west = v({x: coord[:x]-1, y: coord[:y]}, maze)

      ew = value_east == ' ' ? -1 : 1 # go west (-) if east is blank

      return {x: coord[:x] + (ew * 1), y: coord[:y]}, ew == 1 ? 'east' : 'west'
    else
      return {x: coord[:x], y: coord[:y]+1}, last_direction
    end
  when 'east'
    case value
    when '+'
      value_north = v({x: coord[:x], y: coord[:y]-1}, maze)
      value_south = v({x: coord[:x], y: coord[:y]+1}, maze)

      ns = value_north == ' ' ? -1 : 1 # go south (-) if north is blank

      return {x: coord[:x], y: coord[:y] + (ns * 1)}, ns == 1 ? 'north' : 'south'
    else
      return {x: coord[:x]+1, y: coord[:y]}, last_direction
    end
  when 'west'
    case value
    when '+'
      value_north = v({x: coord[:x], y: coord[:y]-1}, maze)
      value_south = v({x: coord[:x], y: coord[:y]+1}, maze)

      ns = value_north == ' ' ? -1 : 1 # go south (-) if north is blank

      return {x: coord[:x], y: coord[:y] + (ns * 1)}, ns == 1 ? 'north' : 'south'
    else
      return {x: coord[:x]-1, y: coord[:y]}, last_direction
    end
  end
end

def v(coord, maze)
  x = coord[:x]
  y = coord[:y]

  return nil unless maze[y]
  return maze[y][x]
end

def is_letter?(char)
  char.match(/^[[:alpha:]]$/)
end

def move(start_coord, last_direction, letters, maze)
  next_location, last_direction = find_move(start_coord, maze, last_direction)

  pp next_location
  while next_location do
    puts "#{v(next_location, maze)} [#{next_location[:x]},#{next_location[:y]}] - {#{last_direction}}"
    letters << v(next_location, maze) if is_letter?(v(next_location, maze))
    next_location, last_direction = find_move(next_location, maze, last_direction)
  end
  letters
end

sample_maze = input('sample')
#pp sample_maze
pp move({x: 5, y: 0}, 'south', [], sample_maze)