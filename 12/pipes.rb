require 'pp'

def input(filename)
  File.read(filename)
    .lines
    .map{|line|
      splits = line.split(' ')
      {
          a: splits[0],
          b: splits.drop(2).map{|s| s.gsub(',', '')}
      }
    }
end

def zero_connected(pipes, connected = [])
  zero_pipe = pipes.find{|p| p[:a] == '0'}
  connected += zero_pipe[:b] if zero_pipe

  pipes.reject{|p| p[:a] == '0'}.each do |pipe|
    pipe[:b].each do |b|
      connected += [b, pipe[:a]] if connected.any?{|c| c == b}
    end
  end
  connected
    .uniq
    .reject{|c| c == '0'}
end

sample = input('sample')
c = []
c = zero_connected(sample, c)
c = zero_connected(sample, c)
pp c.length

sample = input('input')
c = []
c = zero_connected(sample, c)
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
c = zero_connected(sample, c)
pp c.length
