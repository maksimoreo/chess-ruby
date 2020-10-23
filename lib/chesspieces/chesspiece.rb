# frozen_string_literal: true

require_relative 'chess_piece_singleton'

# Base class for chess pieces. ChessPiece objects can be placed on a chess board
class ChessPiece
  extend ChessPieceSingleton
  private_class_method :new

  def self.opposite_color(color)
    color == :white ? :black : :white
  end

  attr_reader :color

  def initialize(color)
    raise "invalid color: #{color}, must be :white or :black" unless color == :white || color == :black

    @color = color
  end

  def to_s
    "#{color} #{name}"
  end

  def name
    self.class.name
  end

  # Returns array of ChessPositions where the chess piece can go from current position
  def available_moves(from, chessboard)
    attack_cells(from, chessboard.grid).select { |move| chessboard.grid.can_move_or_take?(move, color)}
  end

  # Chess pieces attack other pieces of the same color, but cannot move there
  # (pawn attacks side cells, but doesn't attack forward cell)
  # (king can attack cells that are under attack, but can't move there)
  def attack_cells(_from, _cb_grid)
    []
  end

  # Moves ChessPiece from _from to _to on chessboard.
  # Derived class may override this behavior (pawn promotion, castling)
  def move(from, to, chessboard)
    move_is_allowed = available_moves(from, chessboard).include?(to)
    chessboard.grid.move(from, to) if move_is_allowed
    move_is_allowed
  end
end
