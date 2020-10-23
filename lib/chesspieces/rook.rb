require_relative 'chesspiece'
require_relative '../chess_position'
require_relative '../directional_moves'

class Rook < ChessPiece
  include AxisAlignedMoves

  def available_moves(from, chessboard)
    available_moves_axis_aligned(from, chessboard.grid)
  end
end
