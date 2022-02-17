=begin
3 kyu
Your task, is to create a NxN spiral with a given size.

For example, spiral with size 5 should look like this:

00000
....0
000.0
0...0
00000
and with the size 10:

0000000000
.........0
00000000.0
0......0.0
0.0000.0.0
0.0..0.0.0
0.0....0.0
0.000000.0
0........0
0000000000
Return value should contain array of arrays, of 0 and 1, with the first row being composed of 1s.
For example for given size 5 result should be:

[[1,1,1,1,1],[0,0,0,0,1],[1,1,1,0,1],[1,0,0,0,1],[1,1,1,1,1]]
Because of the edge-cases for tiny spirals, the size will be at least 5.

General rule-of-a-thumb is, that the snake made with '1' cannot touch to itself.

Psuedo
-Given N
-Initialize a 2D array of size NxN with all entries of 0.
-Traverse along top row switching all to 1. Break if reach end or +2 == 0.
-Need someway to preserve state of which way we need to go next.
  -Could just switch back and forth. What is loop condition end then?
-Traverse along last column switching all to 1.
-Traverse backwards along bottom row switching all to 1.
-Traverse backwards along top column switching entries to 1 and stopping @ index + 2 == 0
-Break and return arrays
=end

DIRECTIONS = %w[right down left up].freeze

class Snake
  attr_accessor :head_location, :home_size

  def initialize
    @head_location = [0, 0]
  end

  def slither(direction, snake_cage)
    snake_cage.width.times do
      if slither_into_self?(direction, snake_cage)
        slide_back(direction)
        break
      end
      snake_cage.cage[head_location.first][head_location.last] = 1
      increment_location(direction, snake_cage)
    end
  end

  private

  def slither_into_self?(direction, snake_cage)
    case direction
    when 'right' then snake_cage.cage[head_location.first][head_location.last + 1] == 1
    when 'down' then snake_cage.cage[[head_location.first + 1, snake_cage.length - 1].min][head_location.last] == 1
    when 'left' then snake_cage.cage[head_location.first][[head_location.last - 1, 0].max] == 1
    when 'up' then snake_cage.cage[[head_location.first - 1, 0].max][head_location.last] == 1
    end
  end

  def increment_location(direction, snake_cage)
    case direction
    when 'right' then head_location[1] = [head_location[1] + 1, snake_cage.width - 1].min
    when 'down' then head_location[0] = [head_location[0] + 1, snake_cage.width - 1].min
    when 'left' then head_location[1] = [head_location[1] - 1, 0].max
    when 'up' then head_location[0] = [head_location[0] - 1, 0].max
    end
  end

  def slide_back(direction)
    case direction
    when 'right' then head_location[1] -= 1
    when 'down' then head_location[0] -= 1
    when 'left' then head_location[1] += 1
    when 'up' then head_location[0] += 1
    end
  end
end

class SnakeCage
  attr_accessor :length, :width, :cage

  def initialize(max)
    @length = max
    @width = max
    cage_set_up
  end

  private

  def cage_set_up
    @cage = Array.new(length) { Array.new(width) { 0 } }
  end
end

def gen_direction_arr(size)
  rounded = (size / 4.0).ceil
  difference = (rounded * 4) - size
  arr = DIRECTIONS * rounded
  difference.times { arr.pop }
  arr
end

def spiralize(size)
  snake = Snake.new
  cage = SnakeCage.new(size)
  directions = gen_direction_arr(size)
  directions.each do |direction|
    snake.slither(direction, cage)
  end
  cage.cage
end
