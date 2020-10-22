require_relative 'chesspiece'
require_relative '../chess_position'

class Bishop < ChessPiece
  @directions = [[1, 1], [1, -1], [-1, -1], [-1, 1]].map { |e| Point.from_a(e) }.freeze

  class << self
    attr_reader :directions
  end

  def directions
    self.class.directions
  end

  def available_moves(from, chessboard)
    directions.reduce([]) do |moves_array, direction|
      moves_array + available_moves_direction(from, chessboard, direction)
    end
  end

  def available_moves_direction(from, chessboard, direction)
    moves = []

    current_cell = from + direction

    loop do
      break if current_cell.nil? # new cell is not on the chessboard

      destination = chessboard.chess_piece_at(current_cell)

      if destination.nil?
        moves << current_cell
      else
        moves << current_cell if destination.color != color
        break
      end

      current_cell = current_cell + direction
    end

    moves
  end
end
