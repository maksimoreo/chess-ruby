# frozen_string_literal: true

# Base class for chess pieces. ChessPiece objects can be placed on chess board
class ChessPiece
  attr_reader :name, :color

  def initialize(name, color)
    raise "invalid color: #{color}, must be :white or :black" unless color == :white || color == :black

    @name = name
    @color = color
  end

  # Derived classes should implement move(from, to, chessboard)
end
