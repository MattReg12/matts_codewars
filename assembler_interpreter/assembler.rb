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
  p.output
end

module Tokenable
  def remove_comments(program)
    program.gsub(/\;.*$/, '')
  end

  def routines(program)
    program = program.strip
    program.split("\n\n")
  end

  def tokenize(routine)
    routine = routine.split("\n").map { |instruc| instruc.split }
    routine = remove_commas(routine)
    routine
  end

  def remove_commas(routine)
    routine.each do |instruc|
      unless instruc.first == 'msg'
      instruc.join(' ').delete
    end
  end
end

class Program
  include Tokenable

  attr_reader :regs, :output, :main, :subs

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

  #private

  #attr_accessor :prev_cmp

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

  def add(reg, x)
    regs[reg] += value(x)
  end

  def sub(reg, x)
    regs[reg] -= value(x)
  end

  def mul(reg, x)
    regs[reg] *= value(x)
  end

  def div(reg, x)
    regs[reg] /= value(x)
  end

  def cmp(reg_one, reg_two)
    value(reg_one) <=> value(reg_two)
  end

  def call(label)
    execute(subroutines[label.intern])
  end

  def jmp(label)
    execute(subroutines[label.intern])
  end

  def jne(label)
    jmp(label) unless prev_cmp.zero?
  end

  def je(label)
    jmp(label) if prev_cmp.zero?
  end

  def jge(label)
    jmp(label) if prev_cmp >= 0
  end

  def jg(label)
    jmp(label) if prev_cmp.postive?
  end

  def jle(label)
    jmp(label) if prev_cmp <= 0
  end

  def jl(label)
    jmp(label) if prev_cmp.negative?
  end

  def reg_value(reg)
    regs.fetch(reg, reg.to_i)
  end

  def msg_value(msg)
    regs.fetch(msg, msg)
  end

  def msg(*args)
    @output = args.map { |arg| msg_value(arg) }.join
  end

  def parse(instrux)
    instrux = remove_comments(instrux)
    main, *subs = routines(instrux)
    #subs.map! { |sub| tokenize(sub) }
    #record(subs)
    tokenize(main)
  end

  def record(subs)
    @subs = {}
    subs.each do |sub|
      @subs[sub.first.first] = sub[1..-1]
    end
  end
end

program_fibonacci = "
    mov   a, 8            ; value
    mov   b, 0            ; next
    mov   c, 0            ; counter
    mov   d, 0            ; first
    mov   e, 1            ; second
    call  proc_fib
    call  print
    end

    proc_fib:
        cmp   c, 2
        jl    func_0
        mov   b, d
        add   b, e
        mov   d, e
        mov   e, b
        inc   c
        cmp   c, a
        jle   proc_fib
        ret

    func_0:
        mov   b, c
        inc   c
        jmp   proc_fib

    print:
        msg   'Term ', a, ' of Fibonacci series is: ', b        ; output text
        ret
    "

binding.pry

