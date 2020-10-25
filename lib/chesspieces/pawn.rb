# frozen_string_literal: true

require_relative 'chesspiece'

# Pawn chesspiece
class Pawn < ChessPiece
  def available_moves(from, chessboard)
    if color == :white
      available_moves_white(from, chessboard)
    else
      available_moves_black(from, chessboard)
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
      .reject { |move| move.nil? }
  end

  def move(from, to, chessboard)
    # Validate and perform move
    super

    # After move was performed check if pawn can be promoted
    if color == :white && to.i == 7
      # TODO: promote Pawn to Queen
    elsif color == :black && to.j == 0
      # TODO: promote Pawn to Queen
    end
  end

  def available_moves_white(from, chessboard)
    moves = []

    # no moves available if pawn is at the top (*8)
    unless from.i == 7

      # move up is available if nothing is blocking it
      if chessboard.cell_empty?(from.up)
        moves << from.up

        # move two spaces up from start position (*2) if nothing is blocking
        if from.i == 1 && chessboard.cell_empty?(from.up(2))
          moves << from.up(2)
        end
      end

      # capture if cell isn't empty
      moves += attack_cells_direction(from, 1).reject { |move| chessboard.cell_empty?(move) }
    end

    moves
  end

  def available_moves_black(from, chessboard)
    moves = []

    # no moves available if pawn is at the bottom (*1)
    unless from.i == 0

      # move down is available if nothing is blocking it
      if chessboard.cell_empty?(from.down)
        moves << from.down

        # move two spaces down from start position (*7) if nothing is blocking
        if from.i == 6 && chessboard.cell_empty?(from.down(2))
          moves << from.down(2)
        end
      end

      # capture if cell isn't empty
      moves += attack_cells_direction(from, -1).reject { |move| chessboard.cell_empty?(move) }
    end

    moves
  end
end
