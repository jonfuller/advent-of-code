require 'rubygems'
require 'pp'

def get_input
  File.read('input').lines.map{|l| l.chomp}
end

def duplicates?(phrase)
  words = phrase.split(' ')
  counts = words.inject({}){|memo, obj| memo[obj] ||= 0; memo[obj] = memo[obj] + 1; memo}
  counts.values.max > 1
end

def valid?(phrase)
  !duplicates?(phrase)
end

pp valid?("aa bb cc dd ee")
pp valid?("aa bb cc dd aa")
pp valid?("aa bb cc dd aaa")

pp get_input
  .map{|phrase| valid?(phrase) ? 1 : 0}
  .sum
