=begin

P: Build an interpreter that processes assembler like commands,

  Input: Multiline string

  Output: If no `end` instruction then output -1 as int. Else output the string stored by the command
  `msg` earlier in the program.

  basic commands to add
    x is content of register and y is register or int - This is a pain
    -add x, y
    -sub x, y
    -mul x, y
    -div x, y
    -cmp x, y --   <=> equiv
    -

  parsing commands
    -remove comments
      substitue ;.... EOL with nothing.
    -remove trailing and leading spaces/new lines
    -split string on double new line, this will break the program into a main call stack followed by defined subroutines
    -split all strings further on blank space, handle empty arrays
    -perhaps convert ints to integer type to avoid multiple to_int calls
    -define @subroutines hash - symbol as names, remove ret, store others as steps

  program flow --
    -use internal iterators with execute function

  -defining subroutines
    helper method in initialize - define



  Qs -   What if no msg command and end?

E:


D:


A:


C:
=end

def simple_assembler(program)
  p = Program.new(program)
  p.execute
  p.variables
end

class Program
  attr_reader :regs

  def initialize(main)
    @main = parse(main)
    @regs = {}
    @prev_cmp = nil
  end

  def execute(routine=@main)
    routine.each do |inx|
      assemble(inx)
    end
  end

  private

  def assemble(instruction)
    fx, var, arg = instruction
    arg ? send(fx, var, arg) : send(fx, var)
  end

  def mov(reg, value)
    regs[reg] = reg_value(value)
  end

  def inc(reg)
    regs[reg] += 1
  end

  def dec(reg)
    regs[reg] -= 1
  end

  def add(reg, val)
    regs[reg] += value(val)
  end

  def sub(reg, val)
    regs[reg] -= value(val)
  end

  def mul(reg, val)
    regs[reg] *= value(val)
  end

  def div(reg, val)
    regs[reg] /= value(val)
  end

  def cpm(reg_one, reg_two)
    value(reg_one) <=> value(reg_two)
  end

  private

  def reg_value(reg)
    regs.fetch(reg, reg.to_i)
  end

  def parse(instructions)

  end
end

  program_mod = "
  mov   a, 11           ; value1
  mov   b, 3            ; value2
  call  mod_func
  msg   'mod(', a, ', ', b, ') = ', d        ; output
  end

  ; Mod function
  mod_func:
      mov   c, a        ; temp1
      div   c, b
      mul   c, b
      mov   d, a        ; temp2
      sub   d, c
      ret
  "

x = program_mod.gsub(/\;.*$/, '')
main, *fxs = x.strip.split("\n\n").map { |y| y.split("\n") }.each { |z| z.map!(&:split) }.delete_if(&:empty?)
p main
p fxs

