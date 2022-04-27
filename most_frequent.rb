=begin

input: string

output: array of strings

explicit: return the 3 most occurring words
case insensitive
words consists of letters and apostrophes
everything else is whitespace
if less than 3 words, only return a blank or 1-2 sized array


implicit:

questions? What does broken arbitrarily


data struc: string
going to convert this to an array

algo:
init a string by calling squeeze and downcase on the argument.
we are going to delete everything not a letter or '
init an array by splitting the string
init a compare array by calling uniq on our array
init a another array and map it to counts
select or take top 3

=end


def top_3_words(text)
  str = text.squeeze(' ').squeeze('\'').downcase
  str.gsub!(/[^a-z' ]/, '')
  arr = str.split
  return [] if arr.empty? || arr.all? { |word| word == '\'' }

  compare_arr = arr.uniq.sort_by { |word| arr.count(word) }
  [compare_arr[-1], compare_arr[-2], compare_arr[-3]].compact
end
