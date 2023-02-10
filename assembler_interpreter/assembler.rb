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

  program flow --
    -already here

  -defining subroutines
    -define_method(:name) do



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
    @cmp_val = nil
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
    regs[reg] = regs.fetch(value, value.to_i)
  end

  def inc(reg)
    regs[reg] += 1
  end

  def dec(reg)
    regs[reg] -= 1
  end

  private

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

