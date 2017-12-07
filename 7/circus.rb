require 'pp'

def load_input(filename)
  File.read(filename).lines.map{|l| l.chomp}.map{|l|
    splits = l.split(' ')
    {root: splits[0], id: splits[1], children: (splits[3..-1] || []).map{|c| c.gsub(',', '')}}
  }
end

# finds the proc that's only listed once
def find_root(proc_list)
  procs = (proc_list.map{|p| p[:children]} + proc_list.map{|p| p[:root]}).flatten
  counts = procs.inject({}){|memo, obj| memo[obj] ||= 0; memo[obj] += 1; memo }
  counts.find{|p, count| count == 1}
end

pp find_root(load_input('sample'))
pp find_root(load_input('input'))
