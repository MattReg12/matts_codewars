=begin
3 Kyu
Consider a "word" as any sequence of capital letters A-Z (not limited to just "dictionary words").
For any word with at least two different letters, there are other words composed of the same letters
but in a different order (for instance, STATIONARILY/ANTIROYALIST, which happen to both be dictionary
words; for our purposes "AAIILNORSTTY" is also a "word" composed of the same letters as these two).

We can then assign a number to every word, based on where it falls in an alphabetically sorted
list of all words made up of the same group of letters. One way to do this would be to generate the
  entire list of words and find the desired one, but this would be slow if the word is long.

Given a word, return its number. Your function should be able to accept any word 25 letters or less
in length (possibly with some letters repeated), and take no more than 500 milliseconds to run. To
  compare, when the solution code runs the 27 test cases in JS, it takes 101ms.

For very large words, you'll run into number precision issues in JS (if the word's position is
greater than 2^53). For the JS tests with large positions, there's some leeway (.000000001%).
If you feel like you're getting it right for the smaller ranks, and only failing by rounding on
the larger, submit a couple more times and see if it takes.

Python, Java and Haskell have arbitrary integer precision, so you must be precise in those
languages (unless someone corrects me).

C# is using a long, which may not have the best precision, but the tests are locked so we can't
change it.

Sample words, with their rank:
ABAB = 2
AAAB = 1
BAAA = 4
QUESTION = 24572
BOOKKEEPER = 10743
=end

def count_dupe_letters(string)
  arr = string.chars
  uniq_arr = string.chars.uniq
  uniq_arr.each_with_object([]) do |letter, count|
    count << arr.count(letter) if arr.count(letter) > 1
  end
end

def factorial_numerator(string)
  (1..string.length).reduce(&:*)
end

def factorial_denominator(arr)
  arr.reduce(1) { |sum, num| sum * (1..num).reduce(&:*) }
end

def count_idx_change(string)
  string_arr = string.chars
  sorted_string_arr = string.chars.sort
  change = sorted_string_arr.index(string_arr[0])
end

def count_cost_idx_change(string)
  (factorial_numerator(string) / factorial_denominator(count_dupe_letters(string))) / string.length
end

def listPosition(string)
  sum = 1
  until string[0].nil?
    sum += (count_cost_idx_change(string) * count_idx_change(string))
    string.slice!(0)
  end
  sum
end
