require 'rubygems'
require 'pp'

def debug(str)
  pp str
end

def load_input(filename)
  File.read(filename).lines.map{|l| l.chomp.split(' ').map{|x| x.to_i}}
end

def row_value_min_max(row)
  row.max - row.min
end

def row_value_division(row)
  pair = row
    .product(row)
    .reject{|pair| pair[0] == pair[1]}
    .find{|pair| pair[0]%pair[1] == 0}

  pair[0]/pair[1]
end

def row_sum(inputs)
  inputs.inject(0){|sum, row| sum + row_value_division(row)}
end

pp row_sum(load_input("sample2"))
pp row_sum(load_input("input"))
