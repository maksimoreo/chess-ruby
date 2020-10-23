

module DirectionalMoves
  def available_moves_directions(from, cb_grid, directions)
    directions.reduce([]) do |moves, direction|
      moves + available_moves_direction(from, cb_grid, direction)
    end
  end

  def available_moves_direction(from, cb_grid, direction)
    moves = []

    current_cell = from + direction

    loop do
      break if current_cell.nil? # new cell is not on the chessboard

      moves << current_cell if cb_grid.can_move_or_take?(current_cell, color)
      break unless cb_grid.cell_empty?(current_cell)

      current_cell = current_cell + direction
    end

    moves
  end
end

module DiagonalMoves
  # @directions = [[1, 1], [1, -1], [-1, -1], [-1, 1]].map { |e| Point.from_a(e) }.freeze
  include DirectionalMoves

  def available_moves_diagonal(from, cb_grid)
    directions = [[1, 1], [1, -1], [-1, -1], [-1, 1]].map { |e| Point.from_a(e) }
    available_moves_directions(from, cb_grid, directions)
  end
end

module AxisAlignedMoves
  # @directions = [[0, 1], [0, -1], [1, 0], [-1, 0]].map { |e| Point.from_a(e) }.freeze
  include DirectionalMoves

  def available_moves_axis_aligned(from, cb_grid)
    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]].map { |e| Point.from_a(e) }
    available_moves_directions(from, cb_grid, directions)
  end
end
