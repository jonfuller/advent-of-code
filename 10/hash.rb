require 'pp'

def hash_round(values, lengths)
  values = values.dup
  current_position = 0
  skip_size = 0
  lengths.each do |length|
    values = values.rotate(current_position)
    values[0..length-1] = values[0..length-1].reverse if length > 0
    values = values.rotate(-current_position)

    current_position = (current_position + length + skip_size) % values.length
    skip_size += 1
  end
  debug(stringit2(values, current_position, skip_size))
  values
end

res = hash((0..4).to_a, [3, 4, 1, 5])
pp res, res[0..1], res[0]*res[1]

res = hash((0..255).to_a, [227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144])
pp res[0..1], res[0]*res[1]
