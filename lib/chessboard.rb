# frozen_string_literal: true

require_relative 'chessboard_grid'
require_relative 'chess_position'

# Holds information about chess game
# (chessboard, history, castlings)
class Chessboard
  attr_reader :grid

  # Creates an empty chessboard
  def initialize
    @grid = ChessboardGrid.new
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)

    @grid[position]
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)
    raise 'cell is not empty' unless @grid[position].nil?

    @grid[position] = chess_piece
  end

  # Calls #move() method on a chess piece at 'from' position
  def move(from_pos, to_pos)
    chess_piece = @grid[from_pos]

    raise 'move from is empty' if chess_piece.nil?

    # Chess piece moves by its own rules
    move_was_performed = chess_piece.move(from_pos, to_pos, self)

    # Return indicator that move was performed
    move_was_performed
  end

  def available_moves(color)
    # all_available_moves = []
    # for each piece _p on the board
    #   if _color == _p.color
    #     _moves = get available moves
    #     for each move _move in _moves
    #       _new_board = try perform the move _move
    #       unless _new_board.is_check?(color)
    #         all_available_moves << _move
    # return all_available_moves
  end

  def check?(color)
    @grid.each_chess_piece_with_pos.any? do | chess_piece, cpos |
      chess_piece.available_moves(cpos, self).include?(@info[color][:king_pos])
    end
  end
end
