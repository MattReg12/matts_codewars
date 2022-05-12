=begin
Sudoku Background
Sudoku is a game played on a 9x9 grid. The goal of the game is to fill all cells of the grid with digits from 1 to 9, so that each column, each row, and each of the nine 3x3 sub-grids (also known as blocks) contain all of the digits from 1 to 9.
(More info at: http://en.wikipedia.org/wiki/Sudoku)

Sudoku Solution Validator
Write a function validSolution/ValidateSolution/valid_solution() that accepts a 2D array representing a Sudoku board, and returns true if it is a valid solution, or false otherwise. The cells of the sudoku board may also contain 0's, which will represent empty cells. Boards containing one or more zeroes are considered to be invalid solutions.

The board is always 9 cells by 9 cells, and every cell only contains integers from 0 to 9.

Examples
validSolution([
  [5, 3, 4, 6, 7, 8, 9, 1, 2],
  [6, 7, 2, 1, 9, 5, 3, 4, 8],
  [1, 9, 8, 3, 4, 2, 5, 6, 7],
  [8, 5, 9, 7, 6, 1, 4, 2, 3],
  [4, 2, 6, 8, 5, 3, 7, 9, 1],
  [7, 1, 3, 9, 2, 4, 8, 5, 6],
  [9, 6, 1, 5, 3, 7, 2, 8, 4],
  [2, 8, 7, 4, 1, 9, 6, 3, 5],
  [3, 4, 5, 2, 8, 6, 1, 7, 9]
]); // => true
validSolution([
  [5, 3, 4, 6, 7, 8, 9, 1, 2],
  [6, 7, 2, 1, 9, 0, 3, 4, 8],
  [1, 0, 0, 3, 4, 2, 5, 6, 0],
  [8, 5, 9, 7, 6, 1, 0, 2, 0],
  [4, 2, 6, 8, 5, 3, 7, 9, 1],
  [7, 1, 3, 9, 2, 4, 8, 5, 6],
  [9, 0, 1, 5, 3, 7, 2, 1, 4],
  [2, 8, 7, 4, 1, 9, 6, 3, 5],
  [3, 0, 0, 4, 8, 1, 1, 7, 9]
]); // => false

input: 2d array of ints

output: boolean

explicit rules - each row, column and 3x3 grid must contain the numbers 1-9
if any do not, return false.

implicit: none

data struct: arrays

algorithm:
CONSTANT = init an array 1-9

method 1
iterate through the top-level array and check all the sub-arrays (rows) and sort. if all equal then move on

method 2
iterate through the top level array
  select the element at that index for all the arrays
  check to see if all sorted equal our initial array

method 3
3x3s
init a row @ 0
inti column @ 0
loop 9 times
  loop 3 times
    add sliced row[column, 3] to blank arr
    row += 1
  column += 3 if row  is 8
  row = 0 if row == 8

true
=end

VALID_SET = (1..9).to_a

def valid_solution(board)
  valid_rows?(board) && valid_columns?(board) && valid_grids?(board)
end

def valid_rows?(board)
  board.all? { |row| row.sort == VALID_SET }
end

def valid_columns?(board)
  board.each_with_index do |_,index|
    column = board.each_with_object([]) do |subarr, column|
      column << subarr[index]
    end
    return false if column.sort != VALID_SET
  end
  true
end

def valid_grids?(board)
  grids = grids(board)
  grids.all? { |row| row.sort == VALID_SET }
end


def grids(board)
  grids = []
  row = 0
  column = 0
  9.times do
    iteration = []
    3.times do
      iteration << board[row].slice(column,3)
      row += 1
    end
    grids << iteration.flatten
    column += 3 if row == 9
    row = 0 if row == 9
  end
  grids
end


