require 'pp'
def debug(str)
  #pp str
end

def samples
  [
    {input: "{}", groups: 1, score: 1},
    {input: "{{{}}}", groups: 3, score: 6},
    {input: "{{},{}}", groups: 3, score: 5},
    {input: "{{{},{},{{}}}}", groups: 6, score: 16},
    {input: "{<{},{},{{}}>}", groups: 1},
    {input: "{<a>,<a>,<a>,<a>}", groups: 1, score: 1},
    {input: "{{<a>},{<a>},{<a>},{<a>}}", groups: 5},
    {input: "{{<!>},{<!>},{<!>},{<a>}}", groups: 2},
  ]
end

def trash_samples
  [
    {input: '<>', trash: 0},
    {input: '<random characters>', trash: 17 },
    {input: '<<<<>', trash: 3},
    {input: '<{!>}>', trash: 2},
    {input: '<!!>', trash: 0},
    {input: '<!!!>>', trash: 0},
    {input: '<{o"i!a,<{i<a>', trash: 10},
  ]
end

def input
  File.read('input')
end

def parse(input)
  score = 0
  groups = 0
  trash_count = 0
  state = [:NONE]
  input = input.chars
  while(input.length > 0)
    current_input = input.first
    input = input.drop(1)
    debug("#{state} - #{current_input} - #{state.length} - #{trash_count}")
    
    case state.last
    when :NONE
      case current_input
      when '{'
        state.push :WITHIN_GROUP
      when '<'
        state.push :WITHIN_TRASH
      end
    when :WITHIN_GROUP
      case current_input
      when '{'
        state.push :WITHIN_GROUP
      when '}'
        state.pop
        score += state.length
        groups += 1
      when '<'
        state.push :WITHIN_TRASH
      when '!'
        state.push :CANCEL
      end
    when :WITHIN_TRASH
      case current_input
      when '>'
        state.pop
      when '!'
        state.push :CANCEL
      else
        trash_count += 1
      end
    when :CANCEL
      state.pop
    end
  end
  {groups: groups, score: score, trash_count: trash_count}
end

samples.each do |sample|
  pp "-----", {groups: sample[:groups], score: sample[:score]}, parse(sample[:input])
end

trash_samples.each do |sample|
  pp "-----", sample, parse(sample[:input])[:trash_count]
end

pp parse(input)