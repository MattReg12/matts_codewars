=begin

Complete the solution so that it strips all text that follows any of a set of comment markers passed in.
Any whitespace at the end of the line should also be stripped out.

Example:

Given an input string of:

apples, pears # and bananas
grapes
bananas !apples
The output expected would be:

apples, pears
grapes
bananas
The code would be called like so:

result = solution("apples, pears # and bananas\ngrapes\nbananas !apples", ["#", "!"])
# result should == "apples, pears\ngrapes\nbananas"

input: string
outout: string

explicit rules:
  strip all text from a string arg that follows any set of chars from an array arg
  white space to be stripped at end
  do this per new line


algo:
  init a variable to delimit the string into an array by \n
  transform the array
    find where those special chars in the arr arg are. (map arr arg then min)
    slice at lowest
    strip white space
  join arr by \n

=end

x = "apples, pears # and bananas\ngrapes\nbananas !apples"

y = ["#", "!"]

def solution(input, markers)
  new_line_arr = input.split("\n")

  new_line_arr.map! do |line|
    low_arr = markers.map { |marker| line.index(marker) }.compact
    low = low_arr.empty? ? -1 : low_arr.min
    low == -1 ? line[0..low].strip : line[0...low].strip
  end

  new_line_arr.join("\n")
end

