
# Container of 64 spaces for chess pieces
# Allows indexing by ChessPosition object
class ChessboardGrid
  # Creates an empty chess board
  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  def [](position)
    @board[position.i][position.j]
  end

  def []=(position, object)
    @board[position.i][position.j] = object
  end

  def move(from, to)
    self[to] = self[from]
    self[from] = nil
  end
end
