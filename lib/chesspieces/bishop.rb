require_relative 'chesspiece'
require_relative '../chess_position'
require_relative '../directional_moves'

class Bishop < ChessPiece
  include DiagonalMoves

  def available_moves(from, chessboard)
    available_moves_diagonal(from, chessboard.grid)
  end
end
