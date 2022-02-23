# Provides methods to evaluate a string or variables in a mathematical expression.
# Without using the eval method
module Evaluation
  def eval_expr(arr, vars)
    return single_item_expression(arr, vars) if arr.length == 1

    return eval_assignment(arr, vars) if arr.include?('=')

    arr = substitute_vars(arr, vars)
    remove_parens(arr)
    parse_negatives(arr)
    parse_division(arr)
    eval_reduce(arr)
  end

  def eval_reduce(arr)
    arr[0..2] = arr.first.send arr[1].intern, arr[2] until arr.length == 1
    arr.first
  end

  def single_item_expression(arr, vars)
    arr.first.is_a?(String) ? vars.fetch(arr.first) : arr.first
  end

  def eval_assignment(arr, hash)
    if !arr.first.is_a?(String) || ['/', '*', '+', '-', '(', ')', '%'].include?(arr.first)
      raise 'Invalid Assignment Operation'
    end

    hash[arr.first] = eval_expr(arr[2..-1], hash)
  end

  def substitute_vars(arr, hash)
    raise_var_error(arr)
    arr = arr.map do |item|
      hash.fetch(item, item)
    end
    arr.map { |item| item.is_a?(String) && item.length > 1 ? 0 : item }
  end

  def raise_var_error(arr)
    expr_vars = arr.select { |item| item.is_a?(String) && item.length > 1 }
    expr_vars.each { |item| @vars.fetch(item, 0) }
  end

  def remove_parens(arr)
    if arr.first == '('
      arr.shift
      arr.pop
    end
    arr
  end

  def parse_negatives(arr)
    if arr.first == '-'
      arr[0..1] = arr[1] * -1
      arr.prepend(0, '+') if arr.length == 1
    elsif arr.join.match?(/--|\*-|\+-|\/-|%-/)
      arr[-2..-1] = format([arr[-2] + arr.last.to_s])
    end
    arr
  end

  def parse_division(arr)
    return arr[-1] = arr.last.to_f unless arr.include?('/') && (arr.first % arr.last) != 0
  end

  def format(arr)
    arr.map do |item|
      if item == item.to_i.to_s
        item.to_i
      elsif item == item.to_f.to_s
        item.to_f
      else item
      end
    end
  end
end

# Provides functionality to locate the highest priority range in a mathematical expression.
module RangeFinder
  def highest_prio_range(arr)
    if arr.any? { |item| item == '(' }
      find_parethentical_range(arr)
    elsif arr.any? { |item| ['*', '/', '%'].include?(item) }
      find_mult_or_div_range(arr)
    elsif arr.any? { |item| item == '=' }
      find_assignment_range(arr)
    else
      (0..arr[1..-1].index { |item| [Integer, Float].include?(item.class) } + 1)
    end
  end

  def find_assignment_range(arr)
    operater = arr.rindex { |item| item == '=' }
    range_start = operater - 1
    range_end = operater + 1
    (range_start..range_end)
  end

  def find_mult_or_div_range(arr)
    operater = arr.index { |item| ['*', '/', '%'].include?(item) }
    range_start = arr[0..operater].rindex { |item| [Integer, Float].include?(item.class) }
    range_end = arr[operater..-1].index { |item| [Integer, Float].include?(item.class) } + operater
    (range_start..range_end)
  end

  def find_parethentical_range(arr)
    range_start = arr.rindex { |item| item == '(' }
    range_end = arr[range_start..-1].index(')') + range_start
    (range_start..range_end)
  end
end

class Interpreter
  include Evaluation
  include RangeFinder

  def initialize
    @vars = {}
    @functions = {}
    @tokens = []
  end

  def input(expr)
    @tokens = format(tokenize(expr).map { |a| a[0] })
    return '' if @tokens.empty?

    until @tokens.length == 1
      current_range = highest_prio_range(@tokens)
      @tokens[current_range] = eval_expr(@tokens[current_range], @vars)
    end
    single_item_expression(@tokens, @vars)
  end

  private

  def tokenize(program)
    return [] if program == ''

    regex = /\s*([-+*\/\%=\(\)]|[A-Za-z_][A-Za-z0-9_]*|[0-9]*\.?[0-9]+)\s*/
    program.scan(regex).reject { |s| s =~ /^\s*$/ }
  end
end
