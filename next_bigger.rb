=begin
Create a function that takes a positive integer and returns the next bigger
number that can be formed by rearranging its digits. For example:

12 ==> 21
513 ==> 531
2017 ==> 2071
nextBigger(num: 12)   // returns 21
nextBigger(num: 513)  // returns 531
nextBigger(num: 2017) // returns 2071
If the digits can't be rearranged to form a bigger number, return -1 (or nil in Swift):

9 ==> -1
111 ==> -1
531 ==> -1
nextBigger(num: 9)   // returns nil
nextBigger(num: 111) // returns nil
nextBigger(num: 531) // returns nil

input: positive integer

output: positive interger

explicit: find the next bigger number of the argument that you can make by rearranging the nums
return -1 if cannot make a bigger number

implicit:

data structure: Int. array

algorithm:
init a digits array that is sorted
guard clause that says if the number is sorted descendingly, return -1
init the counter
reverse iterate through the number starting @ -2
  manual loop
  split the arr @ counter.
  add the first part of the array + 2nd part sorted descending
  break the loop and return the number if bigger than original.
  decrement the counter

=end
#brute force
# def next_bigger(int)
#   num_arr = int.digits.sort.reverse
#   largest_num = num_arr.join.to_i
#   return -1 if int == num_arr.join.to_i

#   (int + 1..largest_num).each do |num|
#     nums = num.digits
#     next unless num_arr.include?(nums.first)
#     return num if num_arr.all? { |int| nums.count(int) == num_arr.count(int) }
#   end
# end

def next_bigger(int)
  num_arr = int.digits.reverse
  return -1 if int == num_arr.sort.reverse.join.to_i

  counter = -1
  loop do
    counter -= 1
    first_slice = num_arr[0...counter]
    last_slice = num_arr[counter..-1]
    switch = last_slice.sort!.index { |num| num > num_arr[counter] }
    next if switch.nil?
    hinge = last_slice[switch]
    last_slice.slice!(switch)
    sorted_end_num = first_slice + [hinge] + last_slice
    return sorted_end_num.join.to_i if sorted_end_num.join.to_i > int
  end
end
