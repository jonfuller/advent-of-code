require 'pp'

def debug(str)
  pp str
end

def load_input(filename)
  File.read(filename).lines.map{|l| l.chomp}.map{|l|
    splits = l.split(' ')
    {
      root: splits[0],
      weight: splits[1][1..-2].to_i,
      children: (splits[3..-1] || []).map{|c| c.gsub(',', '')}
    }
  }
end

# finds the proc that's only listed once
def find_root(proc_list)
  procs = (proc_list.map{|p| p[:children]} + proc_list.map{|p| p[:root]}).flatten
  counts = procs.inject({}){|memo, obj| memo[obj] ||= 0; memo[obj] += 1; memo }
  root_name = counts.find{|p, count| count == 1}[0]

  proc_list.find{|p| root_name == p[:root]}
end

def proc_for(name, proc_list)
  proc_list.find{|p| p[:root] == name}
end

def find_weight(proc_name, proc_list)
  process = proc_for(proc_name, proc_list)

  process[:weight] + process[:children].inject(0){|sum, child| sum += find_weight(child, proc_list)}
end

def bad_child(proc_name, proc_list)
  root = proc_for(proc_name, proc_list)

  children = root[:children]
    .map{|c| {name: c, weight: proc_for(c, proc_list)[:weight], total_weight: find_weight(c, proc_list)}}
    .group_by{|c| c[:total_weight]}
    .sort_by{|weight, children| children.length}

  off_balance = children[0][1].first
  off_by = children[0][0] - children[1][0]

  debug("-------")
  debug(children)
  debug(off_by)

  bad_child(off_balance[:name], proc_list)
end

sample = load_input('sample')
input = load_input('input')

pp find_root(input)

pp bad_child(find_root(input)[:root], input)