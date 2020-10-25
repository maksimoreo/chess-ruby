require_relative 'chesspiece'
require_relative '../directional_moves'

class King < ChessPiece
  def available_moves(from, chessboard)
    moves = attack_cells(from, chessboard).select do |cell|
      chessboard.can_move_or_take?(cell, color)
    end

    # TODO: castlings

    moves
  end

  # TODO: this function
  def allowed_moves(from, chessboard)
    super
    # Check if castlings are available (see castrling rules)
  end

  # King always attacks 8 cells around it (5 if on the edge, 3 if in the corner)
  def attack_cells(from, _cb_grid)
    moves = (DiagonalMoves.directions + AxisAlignedMoves.directions)
      .reject { |move| (from + move).nil? }
  end

  def move(from, to, chessboard)
    super
    # TODO: check if castling is possible (see castling rules)
    # TODO: update king position and castling info in chessboard
  end
end
