require_relative 'chesspiece'
require_relative '../directional_moves'

class Rook < ChessPiece
  include AxisAlignedMoves

  def attack_cells(from, chessboard)
    attack_cells_axis_aligned(from, chessboard.grid)
  end
end
