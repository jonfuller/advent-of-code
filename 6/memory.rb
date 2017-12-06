require 'rubygems'
require 'pp'

def debug(str)
  #pp str
end

def seen_before?(history, current)
  debug("seen before------")
  debug(history)
  debug(current)
  val = history.any?{|x| x == current}
  debug val
  val
end

def redistribute(blocks)
  max = blocks.max
  index = blocks.find_index{|b| b == max}
  blocks[index] = 0
  (index+1..index+max).to_a.each do |index|
    blocks[index%blocks.length] = blocks[index%blocks.length] + 1
  end
  blocks
end

def detect_loop(initial)
  previous = [initial.clone]

  blocks = redistribute(initial.clone)
  
  until(seen_before?(previous, blocks))
    previous << blocks
    blocks = redistribute(blocks.clone)
  end
  previous.length
end

#pp detect_loop([0, 2, 7, 0])
input = "4	10	4	1	8	4	9	14	5	1	14	15	0	15	3	5".split(' ').map{|x| x.chomp}.map{|x| x.to_i}
pp input
pp detect_loop(input)