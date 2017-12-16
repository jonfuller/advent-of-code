require 'pp'

def next_value(previous, factor)
  (previous * factor) % 2147483647
end

def to_bin(num)
  num.to_s(2).rjust(32, '0')
end

def lowest(bin, length)
  bin[-length..-1]
end

def generate_sequence(start, factor)
  current = start
  (0..Float::INFINITY)
    .lazy
    .map{|_| current = next_value(current, factor)}
end

def generate_divisible(start, factor, divisor)
  generate_sequence(start, factor)
    .find_all{|x| x%divisor == 0}
end

def to_lower_16_bin(num)
  lowest(to_bin(num), 16)
end

def part1(input, factors)
  a = generate_sequence(input[:a], factors[:a]).map{|x| to_lower_16_bin(x)}
  b = generate_sequence(input[:b], factors[:b]).map{|x| to_lower_16_bin(x)}

  a.zip(b)
    .take(40_000_000)
    .find_all{|pair| pair[0] == pair[1]}
    .force
    .length
end

def part2(input, factors, divisor)
  a = generate_divisible(input[:a], factors[:a], divisor[:a]).map{|x| to_lower_16_bin(x)}
  b = generate_divisible(input[:b], factors[:b], divisor[:b]).map{|x| to_lower_16_bin(x)}

  a.zip(b)
    .take(5_000_000)
    .find_all{|pair| pair[0] == pair[1]}
    .force
    .length
end

sample = {a: 65, b: 8921}
input = {a: 591, b: 393}
divisor = {a: 4, b: 8}
factors = {a: 16807, b: 48271}

pp part1(input, factors)
pp part2(input, factors, divisor)