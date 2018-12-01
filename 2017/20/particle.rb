require 'pp'

def input(filename)
  File.read(filename)
    .lines
    .map{|l| /p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/.match(l)}
    .map{|m| m[1..9].map{|i| i.to_i}}
    .each_with_index
    .map{|m, i| mp(i, v(m[0], m[1], m[2]), v(m[3], m[4], m[5]), v(m[6], m[7], m[8]))}
end

def mag(vector)
  Math.sqrt(vector.values.map{|v| v*v}.sum)
end

def distance(vector)
  vector.values.map{|v| v.abs}.sum
end

def vector_add(a, b)
  v(a[:x] + b[:x], a[:y] + b[:y], a[:z] + b[:z])
end

def v(x, y, z)
  {x: x, y: y, z: z}
end

def mp(id, p, v, a)
  {id: id, p: p, v: v, a: a}
end

def move_particle(particle)
  vel = vector_add(particle[:v], particle[:a])
  pos = vector_add(particle[:p], vel)

  mp(particle[:id], pos, vel, particle[:a].dup)
end

def move_field(field)
  field.map{|p| move_particle(p)}
end

def fields(initial)
  field = initial
  (0..Float::INFINITY)
    .lazy
    .map{|_| field = remove_collisions(move_field(field))}
end

def remove_collisions(field)
  hashed = field.inject({}){|memo, obj|
    memo[obj[:p]] ||= []
    memo[obj[:p]] << obj
    memo
  }
  collision_ids = hashed
    .find_all{|k,v| v.length > 1}
    .map{|c| c.last}.flatten.map{|c| c[:id]}

  field.reject{|particle| collision_ids.any?{|c| c == particle[:id]}}
end

sample_particles = [
  mp(0, v(3, 0, 0), v(2, 0, 0), v(-1, 0, 0)),
  mp(1, v(4, 0, 0), v(0, 0, 0), v(-2, 0, 0)),
]

input_particles = input('input')

pp sample_particles.min_by{|x| mag(x[:a])}

min_a = input_particles.map{|p| mag(p[:a])}.min
slowest = input_particles.find_all{|particle| mag(particle[:a]) == min_a}
closest = slowest.min_by{|particle| mag(particle[:v])}

pp closest
p fields(input_particles)
   .map{|f| f.length}
   .take(500)
   .force