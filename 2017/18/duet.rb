require 'pp'

def safe_int(str)
  Integer(str)
rescue ArgumentError
  str
end

def parse_input(filename)
  File.read(filename)
    .lines
    .map{|l|
      splits = l.split(' ')
      argument = safe_int(splits[2]) if splits[2]
      {op: splits[0], register: splits[1], argument: argument}
    }
end

def initialize_registers(instructions)
  instructions.map{|i| i[:register]}.inject({}){|memo, obj| memo[obj] = 0; memo}
end

def run_instruction(instruction, registers, played)
  registers = registers.dup
  register = instruction[:register]
  argument = instruction[:argument].class == Integer ?
    instruction[:argument] :
    registers[instruction[:argument]]

  case instruction[:op]
  when 'snd'
    played = registers[register]
  when 'set'
    registers[register] = argument
  when 'add'
    registers[register] += argument
  when 'mul'
    registers[register] *= argument
  when 'mod'
    registers[register] %= argument
  when 'rcv'
    if registers[register] != 0
      registers[register] = played
      recovered = true
    end
  when 'jgz'
    jumps = argument if registers[register] > 0
  end
  {played: played || played, jumps: jumps || 0, registers: registers, recovered: recovered}
end

def run_program(instructions, initial_state)
  states = [initial_state]

  current_instruction = 0
  result = {played: nil, jumps: 0, registers: initial_state}
  while current_instruction >= 0 && current_instruction < instructions.length do
    result = run_instruction(instructions[current_instruction], states.last, result[:played])
    puts "#{current_instruction} - #{instructions[current_instruction][:op]} - #{result}"
    if result[:jumps] != 0
      current_instruction += result[:jumps]
    else
      current_instruction += 1
    end

    if result[:recovered]
      puts "BREAKING"
      break
    end

    states << result[:registers]
  end
  result[:played]
end

sample_program = parse_input('sample')
input_program = parse_input('input')

pp run_program(sample_program, initialize_registers(sample_program))
pp run_program(input_program, initialize_registers(input_program))