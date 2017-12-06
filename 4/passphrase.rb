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

def duplicates_ana?(phrase)
  words = phrase.split(' ').map{|w| w.chars.sort.join('')}
  counts = words.inject({}){|memo, obj| memo[obj] ||= 0; memo[obj] = memo[obj] + 1; memo}
  counts.values.max > 1
end

def valid1?(phrase)
  !duplicates?(phrase)
end

def valid2?(phrase)
  !duplicates_ana?(phrase)
end

pp valid1?("aa bb cc dd ee")
pp valid1?("aa bb cc dd aa")
pp valid1?("aa bb cc dd aaa")

pp get_input
  .map{|phrase| valid1?(phrase) ? 1 : 0}
  .sum

pp get_input
  .map{|phrase| valid2?(phrase) ? 1 : 0}
  .sum
