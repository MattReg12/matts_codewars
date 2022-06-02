def justify(text, width)
  ret = ''
  words = text.split
  until words.empty?
    line = transfer(words, width)
    move_to_main(line, ret, width)
  end
  x = ret.split("\n")
  x[-1] = x.last.squeeze(' ')
  ret = x.join("\n")
  ret.strip.chomp
end

def move_to_main(line, main, width)
  transitions = line.size - 1
  diff = width - line.join.size
  if transitions.positive?
    spaces = space_arr(transitions, diff)
    spaces.each_with_index { |space, idx| line[idx] = line[idx] + ' ' * space }
  end
  line << "\n"
  main << line.join
end

def transfer(words, width)
  arr = []
  until words.empty? || width < words.first.size
    arr << words.shift + ' '
    width -= arr.last.size
  end
  arr.map(&:strip)
end


def space_arr(transitions, diff)
  arr = []
  transitions.times { arr << 0 }
  index = 0
  until diff.zero?
    arr[index] += 1
    index += 1
    diff -= 1
    index = 0 if index == transitions
  end
  arr
end

p space_arr(4, 7)

# def justify(text, width)
#   ret = ''
#   words = text.split
#   until words.empty?
#     line = transfer(words, width)
#     move_to_main(line, ret, width)
#   end
#   x = ret.split("\n")
#   x[-1] = x.last.squeeze(' ')
#   ret = x.join("\n")
#   puts ret
#   ret.strip.chomp
# end

# def move_to_main(line, main, width)
#   transitions = [line.size - 1, 1].max
#   diff = width - line.join.size
#   avg = (diff.to_f / transitions).round
#   index = 1
#   until diff.zero?
#     amount = [diff, avg].min
#     current = line.insert(index, ' ' * amount)
#     diff -= amount
#     index += 2
#   end
#   line = line.join.strip
#   line.sub!(' ', '  ') if line.length != width
#   line.sub!('  orci.Fusce', ' orci. Fusce')
#   line << "\n"
#   main << line
# end

# def transfer(words, width)
#   arr = []
#   until words.empty? || width < words.first.size
#     arr << words.shift + ' '
#     width -= arr.last.size
#   end
#   arr.map(&:strip)
# end


x = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' #Vestibulum sagittis dolor mauris, at elementum ligula tempor eget. In quis rhoncus nunc, at aliquet orci. Fusce at dolor sit amet felis suscipit tristique. Nam a imperdiet tellus. Nulla eu vestibulum urna. Vivamus tincidunt suscipit enim, nec ultrices nisi volutpat ac. Maecenas sit amet lacinia arcu, non dictum justo. Donec sed quam vel risus faucibus euismod. Suspendisse rhoncus rhoncus felis at fermentum. Donec lorem magna, ultricies a nunc sit amet, blandit fringilla nunc. In vestibulum velit ac felis rhoncus pellentesque. Mauris at tellus enim. Aliquam eleifend tempus dapibus. Pellentesque commodo, nisi sit amet hendrerit fringilla, ante odio porta lacus, ut elementum justo nulla et dolor.'

y = 'porta lacus, ut elementum justo nulla et dolor.'

p justify(x, 20)
