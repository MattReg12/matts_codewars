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
         "+-------+",]

def horizontal_sides(piece)
  piece = piece.split("\n")
  full_horiz_sides(piece)# + partial_length_sides(piece)
end

def full_horiz_sides(piece)
  piece.map.with_index do |line, vertical_idx|
    line = line.gsub('-+-', '---')
    if line =~ /\+-+\+/
      [line, [vertical_idx, line.index('+')], [vertical_idx, line.rindex('+')]]
    end
  end
end

def partial_horiz_sides(piece)
  piece.map.with_index do |line, vertical_idx|
    line.chars.each_with_object do |char|
    end
  end
end
