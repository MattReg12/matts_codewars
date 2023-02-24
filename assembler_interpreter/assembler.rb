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
    routine = routine.split("\n").map do |instruc|
      if instruc.match?(/^ *msg/)
        msg_token(instruc)
      else instruc.split
      end
    end
    routine = remove_commas(routine)
    routine
  end

  def remove_commas(routine)
    routine.each do |fx, arg_one|
      if arg_one
        arg_one.delete!(',') unless fx == 'msg'
      end
    end
  end

  def msg_token(instruc)
    tokenized = ['msg']
    instruc.sub!('msg', '')
    instruc.strip!.squeeze!(' ')
    tokenized += instruc.split(',')
    tokenized.each do |token|
      token.strip!
      token.delete!("'")
    end
  end

end

class Program
  include Tokenable

  attr_reader :regs, :output

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

  attr_accessor :prev_cmp, :subs

  def assemble(instruction)
    fx, var, arg = instruction
    return if ['end', 'ret'].include?(fx)

    arg ? send(fx, var, arg) : send(fx, var)
  end

  def mov(reg, init_val)
    regs[reg] = value(init_val)
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

  def value(reg)
    regs.fetch(reg, reg.to_i)
  end

  def msg_value(msg)
    regs.fetch(msg, msg)
  end

  def msg(*args)
    @output = args.map { |arg| msg_value(arg) }.join().delete("'")
  end

  def call(sub)
    execute(@subs[sub.intern])
  end

  def parse(instrux)
    instrux = remove_comments(instrux)
    main, *subs = routines(instrux)
    subs.map! { |sub| tokenize(sub) }
    record(subs)
    tokenize(main)
  end

  def record(subs)
    @subs = {}
    subs.each do |fx, *routine|
      fx = fx.first.chop.intern
      @subs[fx] = routine
    end
  end
end
