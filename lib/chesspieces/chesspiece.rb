# frozen_string_literal: true

require_relative 'chess_piece_singleton'

# Base class for chess pieces. ChessPiece objects can be placed on a chess board
class ChessPiece
  extend ChessPieceSingleton
  private_class_method :new

  attr_reader :name, :color

  def initialize(name, color)
    raise "invalid color: #{color}, must be :white or :black" unless color == :white || color == :black
    raise 'color parameter must be a string or a symbol' unless name.is_a?(String) || name.is_a?(Symbol)

    @name = name
    @color = color
  end

  def to_s
    "#{color} #{name}"
  end

  # Returns array of ChessPositions where the chess piece can go from current position
  def available_moves(from, chessboard)
    []
  end

  # Moves ChessPiece from _from to _to on chessboard.
  # Derived class may override this behavior (pawn promotion, castling)
  def move(from, to, chessboard)
    move_is_allowed = self.available_moves(from, chessboard).include?(to)

    if move_is_allowed
      chessboard.grid.move(from, to)
    end

    move_is_allowed
  end
end
