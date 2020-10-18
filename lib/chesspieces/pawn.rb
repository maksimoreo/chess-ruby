# frozen_string_literal: true

require_relative 'chesspiece'

# Pawn chesspiece
class Pawn < ChessPiece
  def self.name
    'Pawn'
  end

  def initialize(color)
    super('Pawn', color)
  end

  def name
    'Pawn'
  end

  def allowed_moves(from, chessboard)
    if @color == :white
      allowed_moves_white(from, chessboard.grid)
    else
      allowed_moves_black(from, chessboard.grid)
    end
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

  def allowed_moves_white(from, chessboard_grid)
    moves = []

    # no moves available if pawn is at the top (*8)
    unless from.i == 7

      # move up is available if nothing is blocking it
      if chessboard_grid[from.up].nil?
        moves << from.up

        # move two spaces up is awailable from position (*2) if nothing is blocking
        if from.i == 1 && chessboard_grid[from.up(2)].nil?
          moves << from.up(2)
        end
      end

      # move to the right is available if can take something
      if from.j < 7
        piece = chessboard_grid[from.up.right]
        if !piece.nil? && piece.color == :black
          moves << from.up.right
        end
      end

      # move to the left is available if can take something
      if from.j > 0
        piece = chessboard_grid[from.up.left]
        if !piece.nil? && piece.color == :black
          moves << from.up.left
        end
      end
    end

    moves
  end

  def allowed_moves_black(from, chessboard_grid)
    moves = []

    # no moves available if pawn is at the bottom (*1)
    unless from.i == 0
      # move down is available if nothing is blocking it
      if chessboard_grid[from.down].nil?
        moves << from.down

        # move two spaces down is awailable from position (*7) if nothing is blocking
        if from.i == 6 && chessboard_grid[from.down(2)].nil?
          moves << from.down(2)
        end
      end

      # move to the right is available if can take something
      if from.j < 7
        piece = chessboard_grid[from.down.right]
        if !piece.nil? && piece.color == :white
          moves << from.down.right
        end
      end

      # move to the left is available if can take something
      if from.j > 0
        piece = chessboard_grid[from.down.left]
        if !piece.nil? && piece.color == :white
          moves << from.down.left
        end
      end
    end
  end
end
