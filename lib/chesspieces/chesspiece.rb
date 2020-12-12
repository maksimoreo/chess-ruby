# frozen_string_literal: true

require_relative '../chess_move'
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

  # Returns array of ChessPositions where the chess piece can move from specified position
  # This function discards moves that result in check

  def allowed_moves(from_cell, chessboard)
    map_chess_move_array(from_cell, allowed_cells(from_cell, chessboard))
  end

  def allowed_cells(from_cell, chessboard)
    available_cells(from_cell, chessboard).reject do |to_cell|
      # copy chessboard
      temp_chessboard = chessboard.clone

      # perform the move on a temporary chessboard
      perform_chess_move(ChessMove.new(from_cell, to_cell), temp_chessboard)

      # reject moves that result in check
      temp_chessboard.check?(color)
    end
  end

  # Returns array of ChessPositions where the chess piece can go from current position
  # Doesn't check if king will be under attack after any of these moves
  def available_moves(from_cell, chessboard)
    map_chess_move_array(from_cell, available_cells(from_cell, chessboard))
  end

  def available_cells(from_cell, chessboard)
    attack_cells(from_cell, chessboard).select { |cell| chessboard.can_move_or_take?(cell, color) }
  end

  # Chess pieces attack other pieces of the same color, but cannot move there
  # (pawn attacks side cells, but doesn't attack forward cell)
  # (king can attack cells that are under attack, but can't move there)
  def attack_cells(_from_cell, _chessboard)
    []
  end

  # This function check if move is allowed
  # def try_move(chess_move, chessboard)
  #   move_is_allowed = allowed_moves(chess_move[:from], chessboard).include?(chess_move[:to])
  #   move(chess_move, chessboard) if move_is_allowed
  #   move_is_allowed
  # end

  # Moves ChessPiece on a given chessboard. Accepts move as hash { from:, to: }
  # Derived class may override this behavior (pawn promotion, castling)
  def move(chess_move, chessboard)
    chessboard.reposition(chess_move[:from], chess_move[:to])
  end

  # Same as previous function but accepts ChessMove class
  def perform_chess_move(chess_move, chessboard)
    chessboard.reposition(chess_move.from, chess_move.to)
  end

  private

  def map_chess_move_array(from_cell, to_cells_array)
    to_cells_array.map { |to_cell| ChessMove.new(from_cell, to_cell) }
  end
end
