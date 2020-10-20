
# Container of 64 spaces for chess pieces
# Allows indexing by ChessPosition object
class ChessboardGrid
  attr_reader :board

  # Creates an empty chess board
  def initialize
    @board = Array.new(64)
  end

  def [](position)
    @board[position.i * 8 + position.j]
  end

  def []=(position, object)
    @board[position.i * 8 + position.j] = object
  end

  def move(from, to)
    self[to] = self[from]
    self[from] = nil
  end

  def each_chess_piece
    return to_enum(:each_chess_piece) unless block_given?
    @board.each { |cell| yield(cell) unless cell.nil? }
  end

  def each_chess_piece_with_pos
    return to_enum(:each_chess_piece_with_pos) unless block_given?
    @board.each_with_index do | cell, index |
      yield(cell, ChessPosition.from_i(index)) unless cell.nil?
    end
  end
end
