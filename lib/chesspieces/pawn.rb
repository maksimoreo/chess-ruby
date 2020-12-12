# frozen_string_literal: true

require_relative 'chesspiece'
require_relative 'queen'
require_relative 'rook'
require_relative 'bishop'
require_relative 'knight'

# Pawn chesspiece
class Pawn < ChessPiece
  @promotion = { queen: Queen, rook: Rook, bishop: Bishop, knight: Knight }

  def self.promotion(promote_to, color)
    @promotion.fetch(promote_to, Queen)[color]
  end

  def available_cells(from, chessboard)
    if color == :white
      available_cells_direction(from, chessboard, 1, 1)
    else
      available_cells_direction(from, chessboard, -1, 6)
    end
  end

  def attack_cells(from, _chessboard)
    if color == :white
      attack_cells_direction(from, 1)
    else
      attack_cells_direction(from, -1)
    end
  end

  # Pawn only attacks cells diagonally forward
  def attack_cells_direction(from, row_direction)
    [[row_direction, -1], [row_direction, 1]]
      .map { |direction| from + Point.from_a(direction) }
      .reject(&:nil?)
  end

  def perform_chess_move(chess_move, chessboard)
    super

    # After move was performed check if pawn can be promoted
    if (color == :white && chess_move.to.i == 7) || (color == :black && chess_move.to.i == 0)
      promote(chessboard, chess_move.to, chess_move.promotion)
    end
  end

  def available_cells_direction(from, chessboard, direction, start_row)
    moves = []
    forward = from.up(direction)

    unless forward.nil?
      if chessboard[forward].nil?
        # move one space forward if nothing is blocking
        moves << forward

        # move two spaces forward from start position if nothing is blocking
        if from.i == start_row && chessboard.cell_empty?(forward.up(direction))
          moves << forward.up(direction)
        end

        # capture if cell isn't emtpy
        moves += attack_cells_direction(from, direction).select do |move|
          !chessboard[move].nil? && chessboard[move].color != color
        end

        # TODO: en passant

        # TODO: promotion

      end
    end

    moves
  end

  private

  def promote(chessboard, pos, promote_to)
    chessboard[pos] = Pawn.promotion(promote_to, color)
  end
end
