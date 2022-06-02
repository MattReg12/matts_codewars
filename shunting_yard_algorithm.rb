class Operator
  include Comparable
  attr_reader :value, :sign

  def initialize(operator)
    @sign = operator
    @value = assign_value(operator)
  end

  def assign_value(operator)
    case operator
    when '^' then 3
    when '*' then 2
    when '/' then 2
    when '+' then 1
    when '-' then 1
    when '(' then 0
    end
  end

  def <=>(operator)
    value <=> operator.value
  end
end

def to_postfix(infix)
  char_arr = infix.chars
  operator_stack = []
  postfix = char_arr.each_with_object('') do |char, postfix|
    if char.to_i.to_s == char
      postfix << char
    elsif operator_stack.empty? || char == '('
      operator_stack << Operator.new(char)
    elsif char == ')'
      postfix << operator_stack.pop.sign until operator_stack.last.sign == '('
      operator_stack.pop
    else
      op1 = Operator.new(char)
      op2 = operator_stack.last
      if op2 >= op1
        until operator_stack.empty? || op1 > op2
          postfix << operator_stack.pop.sign
          op2 = operator_stack.last
        end
        operator_stack << op1
      else
        operator_stack << op1
      end
    end
  end
  postfix + (operator_stack.map(&:sign).reverse.join)
end
