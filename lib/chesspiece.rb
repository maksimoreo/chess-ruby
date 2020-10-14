

# Base class for chess pieces. ChessPiece objects can be placed on chess board
class ChessPiece
  def initialize(name)
    @name = name
  end

  # derived classes should implement move(from, to, chessboard)
end
