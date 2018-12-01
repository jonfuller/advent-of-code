require 'pp'

def parse_input(input)
  input
    .split(',')
    .map{|move|
      value = {type: move[0]}
      splits = move[1..move.length-1].split('/')
      case value[:type]
      when 's'
        value.merge(amount: splits[0].to_i)
      when 'x'
        value.merge(a_pos: splits[0].to_i, b_pos: splits[1].to_i)
      when 'p'
        value.merge(a_name: splits[0], b_name: splits[1])
      end
    }
end

def file_input(input)
  parse_input(File.read(input).lines.first)
end

def do_move(lineup, move)
  case move[:type]
  when 's'
    return lineup.rotate(-move[:amount])
  when 'x'
    a = lineup[move[:a_pos]]
    b = lineup[move[:b_pos]]
    lineup[move[:a_pos]] = b
    lineup[move[:b_pos]] = a
    return lineup
  when 'p'
    a_pos = lineup.find_index{|d| d == move[:a_name]}
    b_pos = lineup.find_index{|d| d == move[:b_name]}

    a = lineup[a_pos]
    b = lineup[b_pos]

    lineup[a_pos] = b
    lineup[b_pos] = a
    return lineup
  end
end

def dance(lineup, moves)
  moves
    .inject(lineup){|lineup, move| do_move(lineup, move)}
end

# 1+ 60*(billion/60) .. billion, 60 is the repeat number
def dance_n(lineup, moves)
  (999_999_961..1_000_000_000)
    .each do |_|
      lineup = dance(lineup.dup, moves)
    end
  lineup
end

sample = parse_input("s1,x3/4,pe/b")
input = file_input('input')
simplified = file_input('simplified')

pp dance(('a'..'e').to_a, sample).join
pp dance(('a'..'p').to_a, input).join

pp dance_n(('a'..'p').to_a, input).join