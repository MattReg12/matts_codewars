def simple_assembler(program)
  p = Program.new(program)
  p.execute
  p.variables
end

class Program
  attr_reader :variables

  def initialize(instructions)
    @inst_set = instructions.map(&:split)
    @variables = {}
    @seq_num = 0
  end

  def execute
    until @inst_set[@seq_num].nil?
      assemble(@inst_set[@seq_num])
      @seq_num += 1
    end
  end

  private

  def assemble(instruction)
    fx, var, arg = instruction
    arg ? send(fx, var, arg) : send(fx, var)
  end

  def mov(variable, value)
    @variables[variable] = @variables.fetch(value, value.to_i)
  end

  def inc(variable)
    @variables[variable] += 1
  end

  def dec(variable)
    @variables[variable] -= 1
  end

  def jnz(variable, steps)
    @seq_num = (@seq_num - 1 + steps.to_i) unless @variables.fetch(variable, variable.to_i).zero?
  end
end

code = <<~CODE
  mov c 12
  mov b 0
  mov a 200
  dec a
  inc b
  jnz a -2
  dec c
  mov a b
  jnz c -5
  jnz 0 1
  mov c a
CODE

p simple_assembler(code.split("\n"))
