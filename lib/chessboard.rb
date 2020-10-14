

# Container of 64 spaces for chess figures
class Chessboard
  def self.decode_pos(str)
    raise 'expected string' unless str.is_a?(String)
    raise "invalid position: #{str}" unless str =~ /^[a-h][1-8]$/

    [str[0].ord - 'a'.ord, str[1].to_i - 1]
  end

  def self.encode_pos(array)
    raise 'expected array' unless array.is_a?(Array)
    raise "invalid position #{array}" unless array.size == 2 && array[0].between?(0, 7) && array[1].between?(0, 7)

    [(array[0] + 'a'.ord).chr, (array[1] + 1).to_s].join
  end

  # Creates an empty chess board
  def initialize()
    @board = Array.new(8) { Array.new(8, nil) }
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    position = Chessboard.decode_pos(position)
    @board[position[0]][position[1]]
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end

    position = Chessboard.decode_pos(position)

    raise 'cell is not empty' unless @board[position[0]][position[1]].nil?

    @board[position[0]][position[1]] = chess_piece
  end
end
