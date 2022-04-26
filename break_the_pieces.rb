x =     ["+------------+",
         "|            |",
         "|            |",
         "|            |",
         "+------+-----+",
         "|      |     |",
         "|      |     |",
         "+------+-----+"].join("\n")

y =     ["    +---+",
         "    |   |",
         "+---+   |",
         "|       |",
         "+-------+",].join("\n")

def sides(piece)
  piece = piece.split("\n")
  transposed_piece = transposed_array(piece)
  horizontal_sides(piece) + vertical_sides(transposed_piece)
end

def horizontal_sides(piece)
  full_horiz_sides(piece) + partial_horiz_sides(piece)
end

def full_horiz_sides(piece)
  piece.each_with_object([]).with_index do |(line, arr), vertical_idx|
    line = line.gsub('-+-', '---')
    if line =~ /\+-+\+/
      arr << [line, [vertical_idx, line.index('+')], [vertical_idx, line.rindex('+')]]
    end
  end
end

# brutally ineffiecient but have to solve it the way i can
def partial_horiz_sides(piece)
  piece.each_with_object([]).with_index do |(line, arr), vertical_idx|
    next if line.count('+') < 3
    charachters = line.chars
    charachters.each_with_index do |char, horiz_idx|
      match = charachters[horiz_idx..-1].join.scan(/\+-+\+/).first
      next if match.nil? || char == '-'
      arr << [match, [vertical_idx, horiz_idx], [vertical_idx, horiz_idx + match.length - 1]]
    end
  end
end

def vertical_sides(transposed_array)
  transposed_array.each_with_object([]).with_index do |(line, arr), vertical_idx|
    charachters = line.chars
    charachters.each_with_index do |char, horiz_idx|
      match = charachters[horiz_idx..-1].join.scan(/\+\|+\+/).first
      next if match.nil? ||  char != '+'
      arr << [match, [horiz_idx, vertical_idx], [horiz_idx + match.length - 1, vertical_idx]]
    end
  end
end

def transposed_array(piece)
  trans_array = blank_transposed_array(piece)
  piece.each_with_index do |line, horiz_idx|
    line.chars.each_with_index do |char, vert_idx|
      trans_array[vert_idx][horiz_idx] = char
    end
  end
  trans_array.map(&:join)
end

def blank_transposed_array(piece)
  Array.new(piece.first.length) { Array.new(piece.length) }
end

pp sides(y)
