require './lib/chessboard_grid'
require './lib/chesspieces/pawn'
require './lib/chesspieces/queen'

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

  describe '#find_pos' do
    it 'returns the ChessPosition of the first found chess piece' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('g5')] = Pawn.white
      expect(grid.find_pos(Pawn)).to eql(ChessPosition.from_s('g5'))
    end

    it 'returns nil if not found' do
      expect(ChessboardGrid.new.find_pos(Pawn)).to eql(nil)
    end

    it 'returns nil there is a figure of the same class but different color' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('g5')] = Pawn.white
      expect(grid.find_pos(Pawn, :black)).to eql(nil)
    end
  end

  describe '#check?' do
    it 'returns true if king is under attack' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('e1')] = King.white
      grid[ChessPosition.from_s('e8')] = Queen.black
      expect(grid.check?(:white)).to eql(true)
    end

    it 'returns false if king is under attack by a chess piece of the same color' do
      grid = ChessboardGrid.new
      grid[ChessPosition.from_s('e1')] = King.white
      grid[ChessPosition.from_s('e8')] = Queen.white
      expect(grid.check?(:white)).to eql(false)
    end
  end
end
