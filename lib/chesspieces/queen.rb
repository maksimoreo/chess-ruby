require_relative 'chesspiece'
require_relative '../directional_moves'

class Queen < ChessPiece
  include DiagonalMoves
  include AxisAlignedMoves

  def available_moves(from, chessboard)
    available_moves_diagonal(from, chessboard.grid) + available_moves_axis_aligned(from, chessboard.grid)
  end
end
