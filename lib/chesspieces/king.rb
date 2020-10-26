# frozen_string_literal: true

require_relative 'chesspiece'
require_relative '../directional_moves'
require_relative '../chess_position'

# King chess piece
class King < ChessPiece
  def available_moves(from, chessboard)
    moves = attack_cells(from, chessboard).select do |cell|
      chessboard.can_move_or_take?(cell, color)
    end

    moves += check_casltings(chessboard, from, color == :white ? 0 : 7)

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
      .map { |direction| from + direction }
      .reject { |move| move.nil? }
  end

  def move(from, to, chessboard)
    super
    # TODO: check if performing a castling
    # TODO: update king position and castling info in chessboard
  end

  private

  def check_casltings(chessboard, pos, row)
    moves = []

    check = lambda do |side, rook_column, from, empty_to, no_check_to|
      chessboard.info[color][:castling][side] &&
      chessboard[ChessPosition.new(row, rook_column)] == Rook[color] &&
      (from..empty_to).all? { |n| chessboard.cell_empty?(ChessPosition.new(row, n)) } &&
      (from..no_check_to).none? { |n| chessboard.cell_under_attack?(ChessPosition.new(row, n), ChessPiece.opposite_color(color)) }
    end

    check = lambda do |side, rook_column, empty_from, empty_to, no_check_from, no_check_to|
      chessboard.info[color][:castling][side] &&
      chessboard[ChessPosition.new(row, rook_column)] == Rook[color] &&
      (empty_from..empty_to).all? { |n| chessboard.cell_empty?(ChessPosition.new(row, n)) } &&
      (no_check_from..no_check_to).none? { |n| chessboard.cell_under_attack?(ChessPosition.new(row, n), ChessPiece.opposite_color(color)) }
    end

    if pos == ChessPosition.new(row, 4)
      moves << ChessPosition.from_s('c1') if check.call(:queenside, 0, 1, 3, 2, 4)
      moves << ChessPosition.from_s('g1') if check.call(:kingside, 7, 5, 6, 4, 6)
    end

    moves
  end
end
