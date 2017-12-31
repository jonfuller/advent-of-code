require 'pp'
require 'irb'

def debug(*msg)
  #puts *msg
end

def p_rule(rule)
  output = []
  output << "rule ------------------"
  output << "raw -> #{rule[:raw]}"
  output << p_grid(rule[:pattern])
  output << ""
  output << p_grid(rule[:enhancement])
  output << ""
  output.join("\r\n")
end

def p_grid(grid)
  grid.map{|row| row.map{|c| (c || '_').to_s}.join('')}.join("\r\n")
end

def input(filename)
  File.read(filename).lines.map{|l| parse_rule(l.chomp)}
end

def rotate_grid(grid)
  grid.transpose.map{|r| r.reverse}
end

def flip_grid_x(grid)
  grid.map{|r| r.reverse}
end

def flip_grid_y(grid)
  grid.reverse.map{|r| r.dup}
end


def flip_flop(grid)
  [grid, flip_grid_x(grid), flip_grid_y(grid)]
end

def permute_grid(grid)
  a = rotate_grid(grid)
  b = rotate_grid(a)
  c = rotate_grid(b)

  grids = []
  [grid, a, b, c]
    .map{|g| flip_flop(g)}
    .each{|p| p.each{|g| grids << g}}

  grids
end

def is_match?(grid, pattern)
  permute_grid(grid).any?{|c| c == pattern}
end

def get_square(grid, start_x, start_y, size)
  square = Array.new(size){ Array.new(size, nil) }
  (0...size).each do |j|
    (0...size).each do |i|
      x = i+start_x
      y = j+start_y
      square[j][i] = grid[y][x]
    end
  end
  square
end

def break_grid(grid)
  size = Math.sqrt(grid.flatten.length).to_i
  chunk_size = size.even? ? 2 : 3
  num_chunks = size / chunk_size

  nums = (0...num_chunks).map{|i| i*chunk_size}

  nums.product(nums).map{|y, x| get_square(grid, x, y, chunk_size)}
end

def put_square(grid, sub_grid, start_x, start_y)
  size = sub_grid.length
  (0...size).each do |j|
    (0...size).each do |i|
      x = i+start_x
      y = j+start_y

      grid[y][x] = sub_grid[j][i]
    end
  end
end

def join_grids(grids)
  num_chunks = Math.sqrt(grids.length).to_i
  chunk_size = grids.first.length

  size = num_chunks * chunk_size

  grid = Array.new(size){ Array.new(size, nil) }

  nums = (0...num_chunks).map{|i| i*chunk_size}

  nums.product(nums)
    .map{|y, x| {x: x, y: y}}
    .map.with_index{|xy, i| put_square(grid, grids[i], xy[:x], xy[:y])}

  grid
end

def parse_pattern(pattern)
  pattern.split('/').map{|l| l.chars}
end

def parse_rule(rule)
  splits = rule.split(' => ')
  {
    raw: rule,
    pattern: parse_pattern(splits[0]),
    enhancement: parse_pattern(splits[1])
  }
end

def count_on(grid)
  grid.flatten.find_all{|c| c == '#'}.length
end

def enhance(grid, rules)
  rule = rules
    .find{|r| is_match?(grid, r[:pattern])}

  rule[:enhancement]
end

def iterate(starting_grid, rules, num_iterations)
  grid = starting_grid
  (0...num_iterations).each do |_|
    debug "#{_}---------------", "original grid-- #{grid.first.length}", p_grid(grid)
    sub_grids = break_grid(grid)
    debug "sub grids -- #{sub_grids.length}"
    sub_grids.each{|g| debug p_grid(g), ""}
    enhanced = sub_grids.map{|g| enhance(g, rules)}
    debug "enhanced grids-- #{enhanced.length}"
    enhanced.each{|g| debug p_grid(g), ""}
    grid = join_grids(enhanced)
  end
  grid
end

sample_rules = input('sample')
input_rules = input('input')
starting_grid = [
  ".#.".chars,
  "..#".chars,
  "###".chars,
]

output = iterate(starting_grid, input_rules, 5)
p count_on(output)