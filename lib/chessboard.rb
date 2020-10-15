# frozen_string_literal: true

# Container of 64 spaces for chess pieces
class Chessboard
  # Creates an empty chess board
  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)

    at(position)
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)
    raise 'cell is not empty' unless at(position).nil?

    place_at(chess_piece, position)
  end

  # Calls #move() method on a chess piece at 'from' position
  def move(from_pos, to_pos)
    chess_piece = at(from_pos)
    destination = at(to_pos)

    raise 'move from is empty' if chess_piece.nil?

    # Chess piece cannot move onto chess pieces of the same color
    unless destination.nil?
      raise 'cannot move onto chess piece of the same color' if destination.color == chess_piece.color
    end

    # Chess piece moves by its own rules
    chess_piece.move(from_pos, to_pos, self)
  end

  private

  def at(position)
    @board[position.i][position.j]
  end

  def place_at(object, position)
    @board[position.i][position.j] = object
  end
end
