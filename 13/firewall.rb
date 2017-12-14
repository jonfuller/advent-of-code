require 'pp'

def input(filename)
  File.read(filename)
    .lines
    .map{|l| l.chomp.split(': ')}
    .map{|x| {layer: x[0].to_i, range: x[1].to_i}}
end

def initialize_layer(layer_num, range)
  ports = [nil] * range
  ports[0] = 'S' if range > 0
  {layer_num: layer_num, range: range, direction: 1, ports: ports}
end

def step_layer(layer)
  scanner_location = layer[:ports].find_index{|p| p == 'S'}
  return initialize_layer(layer[:layer_num], layer[:range]) if layer[:range] == 0

  direction = layer[:direction]
  direction = -1 if layer[:ports].last == 'S'
  direction = 1 if layer[:ports].first == 'S'
      
  ports = layer[:ports].dup.rotate(-direction)

  {layer_num: layer[:layer_num], range: layer[:range], direction: direction, ports: ports}
end

def step(firewall)
  firewall.map{|layer| step_layer(layer)}
end

def initial(configuration)
  config_by_layer = configuration.inject({}){|memo, obj| memo[obj[:layer]] = obj[:range]; memo}

  (0..configuration.max_by{|l| l[:layer]}[:layer])
    .map{|layer_num| initialize_layer(layer_num, (config_by_layer[layer_num] || 0))}
end

def ride(initial)
  severity = 0;
  state = initial
  (0...initial.length).each do |step|
    severity += step * state[step][:range] if state[step][:range] > 0 && state[step][:ports].first == 'S'
    state = step(state)
  end
  severity
end

def short_ride(initial)
  state = initial
  (0...initial.length).each do |step|
    return {caught: true, step: step} if state[step][:range] > 0 && state[step][:ports].first == 'S'
    state = step(state)
  end
  {caught: false}
end

def delay_nocatch(initial)
  state = initial

  (0..Float::INFINITY).lazy.map{|i|
    y = {delay: i}.merge(short_ride(state))
    state = step(state)
    y
  }
  .reject{|x| x[:caught]}
  .first
end

initial_sample = initial(input('sample'))
initial_input = initial(input('input'))

pp "single ride"
pp ride(initial_sample)
pp ride(initial_input)

pp "delayed ride"
pp delay_nocatch(initial_sample)
pp delay_nocatch(initial_input)