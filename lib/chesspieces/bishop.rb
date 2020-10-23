require_relative 'chesspiece'
require_relative '../directional_moves'

class Bishop < ChessPiece
  include DiagonalMoves

  def attack_cells(from, cb_grid)
    attack_cells_diagonal(from, cb_grid)
  end
end
