require 'chessboard_grid'

describe ChessboardGrid do
  describe '#[]' do
    it 'returns object at position' do
      grid = ChessboardGrid.new
      expect(grid[ChessPosition.from_s('a1')]).to eql(nil)
    end
  end

  describe '#each_chess_piece_with_pos' do
    it 'returns objects stored in grid with their positions' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('e4')] = Pawn.white # any object
      grid[ChessPosition.from_s('b6')] = 7
      grid[ChessPosition.from_s('g3')] = [] # any object
      expect(grid.each_chess_piece_with_pos.count).to eql(3)
    end
  end

  describe '#each_chess_piece' do
    it 'returns objects stored in grid' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('e4')] = Pawn.white # any object
      grid[ChessPosition.from_s('b6')] = 7
      grid[ChessPosition.from_s('g3')] = [] # any object
      expect(grid.each_chess_piece.count).to eql(3)
    end
  end
end
