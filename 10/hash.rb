require 'pp'

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
    .map{|char| char.to_s(16)}
    .join
end

# res = hash_round((0..4).to_a, [3, 4, 1, 5], 0, 0)[:values]
# pp res, res[0..1], res[0]*res[1]

# res = hash_round((0..255).to_a, [227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144], 0, 0)[:values]
# pp res[0..1], res[0]*res[1]

pp hash('')
pp hash('AoC 2017')
pp hash('1,2,3')
pp hash('1,2,4')
pp hash('227,169,3,166,246,201,0,47,1,255,2,254,96,3,97,144')
