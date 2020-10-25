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

  describe '#==' do
    it 'returns true if two different ChessboardGrid objects contain same chess piece pattern' do
      grid1 = ChessboardGrid.new
      grid1[ChessPosition.from_s('e1')] = King.white
      grid1[ChessPosition.from_s('b6')] = Queen.black

      grid2 = ChessboardGrid.new
      grid2[ChessPosition.from_s('e1')] = King.white
      grid2[ChessPosition.from_s('b6')] = Queen.black

      expect(grid1).to eq(grid2)
    end

    it 'returns false if two different ChessboardGrid objects contain different chess piece patterns' do
      grid1 = ChessboardGrid.new
      grid1[ChessPosition.from_s('e1')] = King.white
      grid1[ChessPosition.from_s('b6')] = Queen.white

      grid2 = ChessboardGrid.new
      grid2[ChessPosition.from_s('e1')] = King.white
      grid2[ChessPosition.from_s('b6')] = Queen.black

      expect(grid1 == grid2).to eq(false)
    end
  end

  describe '#copy' do
    it 'returns a copy of the ChessboardGrid object' do
      grid1 = ChessboardGrid.new
      grid1[ChessPosition.from_s('a5')] = King.black
      grid1[ChessPosition.from_s('g2')] = Queen.white

      grid2 = grid1.clone

      expect(grid1).to eq(grid2)
    end
  end
end
