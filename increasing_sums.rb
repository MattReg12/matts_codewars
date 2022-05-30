#brute

def find_all(n, k)
  start = 10 ** (k - 1)
  end_range = 10 ** k
  x = (start...end_range).each_with_object([]) do |num, arr|
    dig = num.digits
    if dig.sum == n && dig.sort == dig.reverse
      arr << num
    end
  end
  x.empty? ? [] : [x.count, x[0], x[-1]]
end

#dynamic

def find_all(n, k)
  num = ('1' * k).to_i
  end_num = ('9' * k).to_i
  arr = []
  until num > end_num
    dig = num.digits
    rev = dig.reverse
    if dig.sum == n && dig.sort == rev
      arr << num
    end
    num = next_increasing_num(rev, num)
  end
  arr.empty? ? [] : [arr.count, arr[0], arr[-1]]
end

def next_increasing_num(num_arr, num)
  max = num_arr.max
  if max != 9
    num + 1
  else
    algo(num_arr, num)
  end
end

def algo(num_arr, num)
  left_nine = num_arr.index(9)
  count = num_arr.rindex(9) - left_nine
  minus_one = left_nine - 1
  if count.zero?
    num = num + 2 + (num_arr[minus_one])
  else
    sec_count = 0
    num = num + 2 + (num_arr[minus_one])
    until sec_count == count
      num_arr = num.digits.reverse
      sec_count += 1
      num += num_arr[minus_one] * (10**sec_count)
    end
  end
  num
end


p find_all(10, 3)
