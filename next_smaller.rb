=begin

Write a function that takes a positive integer and returns the next smaller positive integer containing the same digits.

For example:

next_smaller(21) == 12
next_smaller(531) == 513
next_smaller(315) == 153
next_smaller(2071) == 2017


next_smaller(9) == -1
next_smaller(135) == -1
next_smaller(1027) == -1  # 0721 is out since we don't write numbers with leading zeros
some tests will include very large numbers.
test data only employs positive integers.


input: integer

output: integer

explicit rules - return the next smallest number you can via rearraning the digits in the number
if you cant make a smaller number return -1

implicit:

algo:
loop from the number down to 1
break if that iteration that iteration size is the same and & is equl



=end

def next_smaller(int)
  arr = int.digits.reverse
  arr.delete_at(1) if arr[1].zero?
  return -1 if arr.sort == arr

  sorted = int.digits.sort
  (int - 9).step(1,-9) do |num|
    num_arr = num.digits.sort
    return num if num_arr == sorted
  end
end

#  5   1   3