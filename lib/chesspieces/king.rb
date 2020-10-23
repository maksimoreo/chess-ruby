require_relative 'chesspiece'
require_relative '../directional_moves'

class King < ChessPiece
  def available_moves(from, chessboard)
    moves = attack_cells(from, chessboard).select do |cell|
      chessboard.grid.can_move_or_take?(cell, color)
      # TODO: also check if cell is not under attack
    end

    # TODO: castlings

    moves
  end

  # King always attacks 8 cells around it (5 if on the edge, 3 if in the corner)
  def attack_cells(from, _cb_grid)
    moves = (DiagonalMoves.directions + AxisAlignedMoves.directions)
      .reject { |move| (from + move).nil? }
  end

  def move(from, to, chessboard)
    super
    # TODO: check if castling is possible (see castling rules)
  end
end
