require_relative 'chesspiece'
require_relative '../directional_moves'

class Queen < ChessPiece
  include DiagonalMoves
  include AxisAlignedMoves

  def attack_cells(from, cb_grid)
    attack_cells_diagonal(from, cb_grid) + attack_cells_axis_aligned(from, cb_grid)
  end
end
