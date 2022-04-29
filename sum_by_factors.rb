=begin

Given an array of positive or negative integers

I= [i1,..,in]

you have to produce a sorted array P of the form

[ [p, sum of all ij of I for which p is a prime factor (p positive) of ij] ...]

P will be sorted by increasing order of the prime numbers. The final result has to be given as a string in Java, C#, C, C++ and as an array of arrays in other languages.

Example:
I = [12, 15] # result = [[2, 12], [3, 27], [5, 15]]
[2, 3, 5] is the list of all prime factors of the elements of I, hence the result.

Notes:

It can happen that a sum is 0 if some numbers are negative!
Example: I = [15, 30, -45] 5 divides 15, 30 and (-45) so 5 appears in the result, the sum of the numbers for which 5 is a factor is 0 so we have [5, 0] in the result amongst others.

input: an array of integers

output: a nested array with sub array containing integers


explicit rules: we need to return an integer if it is a prime factor of one of the numbers in the original array
  return it in an array at the first element.
the 2nd element of the return subarray will be the sum of all the integers in the original array that it is a
  factor of
the return array will be sorted by factor value

implicit rules:

data structure: arrays and nested arrays


algo:
Notes: only need to check the odds other than 2 up to half of largest value

init a blank return array
init a int that is half of the largest num
check for 2
iterate from 3 to half largest
  if prime and its a factor of any of the elements in the arr argument. add to return array
transform the nested array to add an element on the end that is the sum of all elements which it is a factor.

=end

require 'prime'

def sumOfDivided(lst)
  arr = []
  max = (lst.max_by(&:abs)).abs
  arr << 2 if lst.any? { |num| num.even? }
  (3..max).step(2) do |factor|
    arr << factor if factor.prime? && lst.any? { |num| (num % factor).zero? }
  end
  arr.map do |factor|
    sum = lst.select { |num| (num % factor).zero? }.sum
    [factor, sum]
  end
end