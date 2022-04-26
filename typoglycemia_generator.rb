=begin

input: string

output: string

explicit: first and last chars are to keep the same index
chars between sort alpha
punctuation stays the same place
ignore case

implicit:
return empty string if empty
only do this to the separated words, not the whole string
special chars at the end dont count as the first and last chars


data struc: string


algo:
could guard clause strings 3 size and under

convert this to an array
per word:

  Done -- find the indices and characters that need to be changed.   ewo
  hash with index as key and char as value
  sort the values
  run an each on the hash updating the values

join

=end


def scramble_words(words)
  arr = words.split
  arr.map! do |word|
    word = word.chars
    changer(word, changes(word))
  end
  arr.join(' ')
end


def changes(arr)
  first_letter = arr.index { |char| char =~ /\w/}
  last_letter = arr.rindex { |char| char =~ /\w/}
  hash = arr.each_with_object({}).with_index do |(letter, hash), idx|
    if letter =~ /\w/ && ![first_letter, last_letter].include?(idx)
      hash[idx] = letter
    end
  end
end

def changer(arr, hash)
  sorted = hash.values.sort
  iterator = 0
  hash.each do |k, v|
    hash[k] = sorted[iterator]
    iterator += 1
    arr[k] = hash[k]
  end
  arr.join
end
