=begin
3 Kyu

Write a method that takes a field for well-known board game "Battleship" as an argument and '
returns true if it has a valid disposition of ships, false otherwise. Argument is guaranteed to be
10*10 two-dimension array. Elements in the array are numbers, 0 if the cell is free and 1 if occupied by ship.

Battleship (also Battleships or Sea Battle) is a guessing game for two players.
Each player has a 10x10 grid containing several "ships" and objective is to destroy enemy's forces by
targetting individual cells on his field. The ship occupies one or more cells in the grid.
Size and number of ships may differ from version to version. In this kata we will use Soviet/Russian
version of the game.

Before the game begins, players set up the board and place the ships accordingly to the following rules:
There must be single battleship (size of 4 cells), 2 cruisers (size 3), 3 destroyers (size 2) and 4 submarines
(size 1). Any additional ships are not allowed, as well as missing ships.
Each ship must be a straight line, except for submarines, which are just single cell.

The ship cannot overlap or be in contact with any other ship, neither by edge nor by corner.
=end

def validate_battlefield(field)
  total_hits = field.map.with_index do |line, row|
    line.map.with_index { |position, column| position.zero? ? nil : [row, column] }.compact.flatten(1)
  end
  row_matches = generate_rows_or_columns(total_hits, 'rows')
  column_matches = generate_rows_or_columns(total_hits, 'columns')
  single_hits = (total_hits - (row_matches + column_matches).flatten(1)).product
  ship_count_valid?(row_matches, column_matches, single_hits) && ship_positions_valid?(single_hits, field)
end

def ship_count_valid?(rows, columns, singles)
  ships = { 4 => 1, 3 => 2, 2 => 3, 1 => 4 }
  ship_lengths = (rows + columns + singles).map(&:length)
  return false if ship_lengths.max > 4

  ship_lengths.each { |length| ships[length] -= 1 }
  ships.values.all?(&:zero?)
end

def generate_rows_or_columns(total_hits, rows_or_column)
  row, column = rows_or_column == 'rows' ? [0, 1] : [1, 0]
  total_hits.sort_by! { |hit| [hit.last, hit.first] } if rows_or_column == 'columns'
  total_hits = total_hits.chunk_while do |a, b|
    a[row] == b[row] && a[column].next == b[column]
  end
  total_hits.to_a.delete_if { |hit| hit.length < 2 }
end

def ship_positions_valid?(single_hits, field)
  surrounding_points = single_hits.flatten(1).each_with_object([]) do |single, surrounding_points|
    field[[single[0] - 1, 0].max..[single[0] + 1, 10].min].map do |line|
      line.each.with_index do |point, idx|
        surrounding_points << point if (single[1] - 1..single[1] + 1).include?(idx)
      end
    end
  end
  surrounding_points.flatten.count(1) == single_hits.length
end
