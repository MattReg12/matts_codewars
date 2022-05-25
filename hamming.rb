#brute

require 'prime'

def hamming(n)
  arr = [1]
  num = 2
  until arr.size == n
    factors = num.prime_division.map(&:first)
    arr << num if factors.last <= 5
    num += 1
  end
  arr.last
end

#gets to 225

#dynamic

def hamming(n)
  arr =[1]
  i = 0
  j = 0
  k = 0
  (1..n - 1).each do |nth|
    next_two = arr[i] * 2
    next_three = arr[j] * 3
    next_five = arr[k] * 5
    arr[nth] = [next_two, next_three, next_five].min
    i += 1 if arr[nth] == next_two
    j += 1 if arr[nth] == next_three
    k += 1 if arr[nth] == next_five
  end
  arr.last
end

p hamming(150)
