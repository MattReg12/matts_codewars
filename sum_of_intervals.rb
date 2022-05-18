=begin

Write a function called sumIntervals/sum_intervals() that accepts an array of intervals, and returns the sum of all the interval lengths. Overlapping intervals should only be counted once.

Intervals
Intervals are represented by a pair of integers in the form of an array. The first value of the interval will always be less than the second value. Interval example: [1, 5] is an interval from 1 to 5. The length of this interval is 4.

Overlapping Intervals
List containing overlapping intervals:

[
   [1,4],
   [7, 10],
   [3, 5]
]
The sum of the lengths of these intervals is 7. Since [1, 4] and [3, 5] overlap, we can treat the interval as [1, 5], which has a length of 4.

Examples:
sumIntervals( [
   [1,2],
   [6, 10],
   [11, 15]
] ); // => 9

sumIntervals( [
   [1,4],
   [7, 10],
   [3, 5]
] ); // => 7

sumIntervals( [
   [1,5],
   [10, 20],
   [1, 6],
   [16, 19],
   [5, 11]
] ); // => 19

input: 2d array
output: integer

explicit rules: take the difference of 2 element array if it is a valid interval
a valid interval is one whose endpoint is not within the range of another interval
if end point is within that range then must determine the start of the range -- the lowest of both compared intervals
sum all differences.

data struc: 2d array

algo:

nested loop
iterate through the array
   if the starting value of any array is between a sub_arr then transform its initial value to that
      first one
      is there a match? helper
      if so, find the lowest match and change that first number helper
   if the arrays start with the same number, delete the one if the lower last value
   sum differences of last - first


=end

def sum_of_intervals(intervals)
  intervals.flat_map { |x,y| [*x...y] }.uniq.size
end

p sum_of_intervals([[1, 5], [10, 20], [1, 6], [16, 19], [5, 11]] )