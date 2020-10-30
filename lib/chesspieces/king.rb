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

    castlings = available_castlings(chessboard, from, color == :white ? 0 : 7)

    moves + castlings
  end

  def allowed_moves(from, chessboard)
    moves = attack_cells(from, chessboard).select do |cell|
      chessboard.can_move_or_take?(cell, color) &&
        !chessboard.cell_under_attack?(cell, ChessPiece.opposite_color(color))
    end

    castlings = allowed_castlings(chessboard, from, color == :white ? 0 : 7)

    moves + castlings
  end

  # King always attacks 8 cells around it (5 if on the edge, 3 if in the corner)
  def attack_cells(from, _chessboard)
    (DiagonalMoves.directions + AxisAlignedMoves.directions)
      .map { |direction| from + direction }
      .reject(&:nil?)
  end

  def move(chess_move, chessboard)
    # Move King
    chessboard.reposition(chess_move[:from], chess_move[:to])

    # Move Rook if performing a castling
    row = chess_move[:from].i
    if chess_move[:from].j == 4 && (row == 0 || row == 7)
      if chess_move[:to].j == 2 # Queenside
        chessboard.reposition(ChessPosition.new(row, 0), ChessPosition.new(row, 3))
      elsif chess_move[:to].j == 6 # Kingside
        chessboard.reposition(ChessPosition.new(row, 7), ChessPosition.new(row, 5))
      end
    end

    # disallow castling
    chessboard.info[color][:castling][:queenside] = false
    chessboard.info[color][:castling][:kingside] = false
  end

  private

  def available_castlings(chessboard, pos, row)
    moves = []

    check = lambda do |side, rook_column, empty_from, empty_to|
      (
        row == 0 && pos == ChessPosition.from_s('e1') ||
        pos == ChessPosition.from_s('e8')
      ) &&
        chessboard.info[color][:castling][side] &&
        chessboard[ChessPosition.new(row, rook_column)] == Rook[color] &&
        (empty_from..empty_to).all? { |n| chessboard.cell_empty?(ChessPosition.new(row, n)) }
    end

    if pos == ChessPosition.new(row, 4)
      moves << ChessPosition.new(row, 2) if check.call(:queenside, 0, 1, 3)
      moves << ChessPosition.new(row, 6) if check.call(:kingside, 7, 5, 6)
    end

    moves
  end

  def allowed_castlings(chessboard, from, row)
    available_castlings(chessboard, from, row).select do |move|
      range = [from.j, move.j].minmax
      (range[0]..range[1]).none? { |n| chessboard.cell_under_attack?(ChessPosition.new(row, n), ChessPiece.opposite_color(color)) }
    end
  end
end
