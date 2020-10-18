# frozen_string_literal: true

require 'chessboard_grid'

# Holds information about chess game
# (chessboard, history, castlings)
class Chessboard
  # Creates an empty chess board
  def initialize
    @board = ChessboardGrid.new
  end

  def grid
    @board
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)

    @board[position]
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)
    raise 'cell is not empty' unless @board[position].nil?

    @board[position] = chess_piece
  end

  # Calls #move() method on a chess piece at 'from' position
  def move(from_pos, to_pos)
    chess_piece = @board[from_pos]

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

  def is_check?(color)
    # find king's position
    # find any piece that is attacking king's position
    # return true if found
  end
end
