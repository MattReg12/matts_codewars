=begin

input: string

output: integer

explicit: return the number of substrings that when converted to an int are odd

implicit:

data struc: string

algo:
generate all of the substrings and call to int
reduce them by odd?

=end


def solve(str)
  nums = str.chars
  nums.each_with_object([]).with_index do |(char, count), idx|
    idx.upto(nums.size - 1) do |end_range|
      num = nums[idx..end_range].join.to_i
      count << num if num.odd?
    end
  end.size
end

p solve('1341')