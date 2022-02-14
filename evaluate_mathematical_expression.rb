=begin
2 Kyu

Instructions
Given a mathematical expression as a string you must return the result as a number.

Numbers
Number may be both whole numbers and/or decimal numbers. The same goes for the returned result.

Operators
You need to support the following mathematical operators:

Multiplication *
Division / (as floating point division)
Addition +
Subtraction -
Operators are always evaluated from left-to-right, and * and / must be evaluated before + and -.

Parentheses
You need to support multiple levels of nested parentheses, ex. (2 / (2 + 3.33) * 4) - -6

Whitespace
There may or may not be whitespace between numbers and operators.

An addition to this rule is that the minus sign (-) used for negating numbers and parentheses will
never be separated by whitespace. I.e all of the following are valid expressions.

1-1    // 0
1 -1   // 0
1- 1   // 0
1 - 1  // 0
1- -1  // 2
1 - -1 // 2
1--1   // 2

6 + -(4)   // 2
6 + -( -4) // 10
And the following are invalid expressions

1 - - 1    // Invalid
1- - 1     // Invalid
6 + - (4)  // Invalid
6 + -(- 4) // Invalid
Validation
You do not need to worry about validation - you will only receive valid mathematical expressions
following the above rules.

=end

def clean_input(str)
  str.gsub!(/[+\/*]/) { |operator| ' ' + operator + ' '}
  str.gsub!(/- /, ' - ')
  str.gsub!(/-\(-\(/, '')
  str
end

def highest_priority_range(arr)
  arr = arr.map(&:to_s)
  if arr.any? { |item| item.include?('(') && item.include?(')') }
    index = arr.index { |item| item.include?('(') && item.include?(')') }
    (index..index)
  elsif arr.any? { |item| item.include?('(')}
    (arr.rindex { |z| z.include?('(') }.to_i..arr.index { |a| a.include?(')') }.to_i)
  elsif arr.any? { |item| ['*', '/'].include?(item) }
    operator = arr.index { |y| y == '*' || y == '/' }
    (operator - 1..operator + 1)
  else (0..2)
  end
end

def format_math_expr(arr, negated = 1)
  if arr.first.include?('-(')
    arr.first.delete_prefix!('-')
    negated = -1
  end
  arr = arr.join(' ').gsub(/[()]/, '').split
  arr.map! do |item|
    case
    when item.include?('.') then item.to_f
    when ['*', '+', '-', '/'].include?(item) then item
    else item.to_i
    end
  end
  arr.push(negated)
end

def eval_math_expr(arr)
  return arr.first * arr.last if arr.length == 2
  return (arr.first + arr[1]) * arr.last if arr.length == 3 && !arr.include?(/[\/*-+]/)
  return ((arr.first.send arr[1].intern, arr[-2]) * arr.last).to_f if arr.length == 4
  current_range = highest_priority_range(arr)
  arr[current_range] = eval_math_expr(arr[current_range])
  eval_math_expr(arr)
end

def calc(expression)
  expression = clean_input(expression)
  return [expression.split.first.to_i, expression.split.first.to_f.round(3)].max if expression.scan(/\S+/).length == 1
  exp = expression.scan(/\S+/)
  # binding.pry
  exp[highest_priority_range(exp)] = eval_math_expr(format_math_expr(exp[highest_priority_range(exp)]))
  calc(exp.join(' '))
end

p calc('(- 19)')


'(123.45 * (678.90  /  (-2.5 +  11.5)-(((80 -(19)))  * 33.25))  /  20)  - (123.45 * (678.90  /  (-2.5 +  11.5)-(((80 -(19)))  * 33.25))  /  20)  +  (13  - 2) /  -(-11) '