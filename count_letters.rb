require 'benchmark'

=begin

input: string

output: hash

explicit: must return a hash with the letters in a string (interned) returned as the keys of the hash and the counts of the strings
returned as the values

implicit: I'd ask about case or spaces

data struc: string
convert to array

algo:
init a variable and set to calling chars on string
could use each_with_object or delete with counts? which is faster. we will see

=end


def letter_count(str)
  hash = Hash.new(0)
  letters = str.chars
  letters.each do |char|
    hash[char.intern] += 1
  end
  hash
end


def letter_count_two(str)
  letters = str.chars
  letters.each_with_object({}) do |char, hash|
    hash.has_key?(char.intern) ? hash[char.intern] += 1 : hash[char.intern] = 1
  end
end

input = 'arithmetics'
n = 50000

Benchmark.bm do |benchmark|
  benchmark.report('each') do
    n.times { letter_count(input) }
  end

  benchmark.report('ewo') do
    n.times { letter_count_two(input) }
  end
end
