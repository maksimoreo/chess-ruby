# frozen_string_literal: true

# Container of 64 spaces for chess pieces
class Chessboard
  def self.decode_pos(str)
    raise 'expected a string' unless str.is_a?(String)
    raise "invalid position: #{str}" unless str =~ /^[a-h][1-8]$/

    [str[0].ord - 'a'.ord, str[1].to_i - 1]
  end

  def self.encode_pos(array)
    raise 'expected an array' unless array.is_a?(Array)
    raise "invalid position #{array}" unless array.size == 2 && array[0].between?(0, 7) && array[1].between?(0, 7)

    [(array[0] + 'a'.ord).chr, (array[1] + 1).to_s].join
  end

  # Creates an empty chess board
  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    position = Chessboard.decode_pos(position)
    at(position)
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end

    position = Chessboard.decode_pos(position)

    raise 'cell is not empty' unless @board[position[0]][position[1]].nil?

    place_at(chess_piece, position)
  end

  # Calls #move() method on a chess piece at 'from' position
  def move(from, to)
    from_pos = Chessboard.decode_pos(from)
    to_pos = Chessboard.decode_pos(to)
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
    @board[position[0]][position[1]]
  end

  def place_at(object, position)
    @board[position[0]][position[1]] = object
  end
end
