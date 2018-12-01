require 'rubygems'
require 'pp'
require 'bundler/setup'
require 'rgl/adjacency'
require 'rgl/connected_components'

def input(filename)
  File.read(filename)
    .lines
    .map{|line|
      splits = line.split(' ')
      {
          a: splits[0].to_i,
          b: splits.drop(2).map{|s| s.gsub(',', '').to_i}
      }
    }
end

def graphit(input)
  graph = RGL::AdjacencyGraph.new
  input.each do |connections|
    connections[:b].each do |b|
      graph.add_edge(connections[:a], b)
    end
  end
  graph
end

def zero_group(graph)
  groups(graph).find{|cc| cc.any?{|v| v == 0}}.length
end

def groups(graph)
  ccs = []
  graph.each_connected_component { |c| ccs << c }
  ccs
end

sample = graphit(input('sample'))
input = graphit(input('input'))

pp zero_group(sample)
pp zero_group(input)

pp groups(sample).length
pp groups(input).length