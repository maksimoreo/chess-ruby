require_relative 'chesspiece'
require_relative '../directional_moves'

class Rook < ChessPiece
  include AxisAlignedMoves

  def attack_cells(from, cb_grid)
    attack_cells_axis_aligned(from, cb_grid)
  end

  def move(from, to, chessboard)
    super
    # TODO: update and castling info in cb_grid
  end
end
