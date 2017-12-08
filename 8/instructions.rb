require 'pp'

def load_input(filename)
  File.read(filename).lines.map{|l|
    splits = l.split(' ')
    register = splits[0]
    operation = splits[1]
    argument = splits[2]
    condition = splits[4..6]
    {
      register: register,
      operation: operation,
      argument: argument.to_i,
      condition: {register: condition[0], operator: condition[1], comparison: condition[2].to_i}
    }
  }
end

def conditional(condition, registers)
  operator = condition[:operator]
  register_value = registers[condition[:register]]
  comparison = condition[:comparison]

  case operator
  when '>'
    register_value > comparison
  when '>='
    register_value >= comparison
  when '=='
    register_value == comparison
  when '<'
    register_value < comparison
  when '<='
    register_value <= comparison
  when '!='
    register_value != comparison
  end
end

def run_instruction(instruction, registers)
  register = registers[instruction[:register]]

  case instruction[:operation]
  when 'inc'
    registers[instruction[:register]] += instruction[:argument] if (conditional(instruction[:condition], registers))
  when 'dec'
    registers[instruction[:register]] -= instruction[:argument] if (conditional(instruction[:condition], registers))
  end
end

def run_program(instructions, initial_state)
  registers = initial_state
  instructions.each do |i|
    run_instruction(i, registers)
  end
  registers
end

def max_registers(instructions)
  # initialize all registers to zero
  registers = instructions.map{|i| i[:register]}.inject({}){|memo, obj| memo[obj] = 0; memo}
  run_program(instructions, registers).values.max
end

sample = load_input('sample')
input = load_input('input')

pp max_registers(sample)
pp max_registers(input)