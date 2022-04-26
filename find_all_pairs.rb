=begin

input: array of integers

output: integer

explicit: count the number of pairs in an array
can be empty or only 1 value --- return 0
only count evenly divisible pairs i.e. a count of 7 means 3 pairs
max array length is 1000 with values between 0 and 1000


implicit:


data struc: array

algo:
init a uniq'd array
transform it via the count / 2.
return arr.sum

=end


def pairs(arr)
  uniq_arr = arr.uniq
  sum_arr = uniq_arr.map { |num| arr.count(num) / 2 }
  sum_arr.sum
end