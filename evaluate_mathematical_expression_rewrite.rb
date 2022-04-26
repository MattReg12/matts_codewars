def scrub_input(string)
  string.gsub!(/[\/*+\)]/) { |non_numeric| ' %s ' % non_numeric }
  string.gsub!(/[\(]/, '( ')
  string.gsub!(/\d-/) { |item| item[0] + ' ' + item[1] }
  string
end

def to_arr(string)
  string.scan(/\S+/)
end

def format_numerals(arr)
  non_numerals = ['*', '/', '+', '-', '(', ')', '-(']
  arr.map do |item|
    if non_numerals.include?(item)
      item
    elsif item.include?('.')
      item.to_f
    else item.to_i
    end
  end
end

def highest_prio_range(arr)
  arr = arr.flatten
  if arr.any? { |item| ['(', '-('].include?(item) }
    find_parethentical_range(arr)
  elsif arr.any? { |item| ['*', '/'].include?(item) }
    find_mult_or_div_range(arr)
  else
    (0..2)
  end
end

def find_mult_or_div_range(arr)
  operater = arr.index { |item| ['*', '/'].include?(item) }
  range_start = arr[0..operater].rindex { |item| item.is_a?(Integer) || item.is_a?(Float) }
  range_end = arr[operater..-1].index { |item| item.is_a?(Integer) || item.is_a?(Float) } + operater
  (range_start..range_end)
end

def find_parethentical_range(arr)
  range_start = arr.rindex { |item| ['(', '-('].include?(item) }
  range_end = arr[range_start..-1].index(')') + range_start
  (range_start..range_end)
end

def eval_expr(arr, negated = 1)
  negated = -1 if arr.first == '-('
  arr = arr.delete_if { |item| ['(', ')', '-('].include?(item) }
  case
  when arr.length == 1 then [arr.first * negated]
  when arr.all? { |item| item.is_a?(Integer) || item.is_a?(Float) } then [arr.reduce(&:+) * negated]
  when arr.length == 3
    if arr[1] == '/'
      [(arr.first.send arr[1].intern, arr.last.to_f) * negated]
    else
      [(arr.first.send arr[1].intern, arr.last) * negated]
    end
  else
    current_range = highest_prio_range(arr)
    arr[current_range] = eval_expr(arr[current_range])
    eval_expr(arr, negated)
  end
end

def calc(string)
  string = scrub_input(string)
  arr = format_numerals(to_arr(string))
  until arr.length == 1
    current_range = highest_prio_range(arr)
    arr[current_range] = eval_expr(arr[current_range]).first
  end
  arr.first
end
