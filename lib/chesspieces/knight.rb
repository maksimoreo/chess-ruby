require_relative 'chesspiece'
require_relative '../chess_position'
require_relative '../chessboard'

class Knight < ChessPiece
  @name = 'Knight'

  # 8 default knight's moves
  @default_moves = [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]].map do |array|
    Point.from_a(array)
  end

  def self.default_moves
    @default_moves
  end

  def available_moves(from, chessboard)
    Knight.default_moves.map { |pos| from + pos }.reject { |pos| pos.nil? }.select do |pos|
      destination = chessboard.chess_piece_at(pos)
      destination.nil? || destination.color != color
    end
  end
end
