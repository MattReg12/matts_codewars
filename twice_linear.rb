=begin

Consider a sequence u where u is defined as follows:

The number u(0) = 1 is the first one in u.
For each x in u, then y = 2 * x + 1 and z = 3 * x + 1 must be in u too.
There are no other numbers in u.
Ex: u = [1, 3, 4, 7, 9, 10, 13, 15, 19, 21, 22, 27, ...]

1 gives 3 and 4, then 3 gives 7 and 10, 4 gives 9 and 13, then 7 gives 15 and 22 and so on...

Task:
Given parameter n the function dbl_linear (or dblLinear...) returns the element u(n) of the ordered (with <) sequence u (so, there are no duplicates).

Example:
dbl_linear(10) should return 22

Note:
Focus attention on efficiency

input: int

output: int

explicit rules: starting with one, apply 2 formulas to last batch of added elements:
  n * 2 + 1
  n * 3 + 1
generate a sequence like this until the total elements in a collection reach the argument

implicit:

data struc: int
arrays

algo:
intitalize our main array as blank
initialize a last_added variable to [1]
loop until main array size is equal or > than argument
  lastadded = iterate through last_added and apply both formulas and add results to return array
    add to ewo's array
  break if main array >= argument
end
main array element reference of argument

=end

def dbl_linear(n)
  main_arr = []
  last_added = [1]
  until main_arr.size >= n*5 #(sloppy)
    main_arr += last_added
    last_added = last_added.each_with_object([]) do |num, arr|
      arr << num * 2 + 1
      arr << num * 3 + 1
    end
  end
  main_arr.uniq.sort[n]
end
