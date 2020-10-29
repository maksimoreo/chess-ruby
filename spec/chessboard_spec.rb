require './lib/chessboard'
require './lib/chesspieces/pawn'
require './lib/chesspieces/queen'

describe Chessboard do
  describe '.default_chessboard' do
    it 'returns default chessboard' do
      cb = Chessboard.default_chessboard

      # Other chess pieces
      [[0, :white], [7, :black]].each do |row, color|
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |chess_piece, column|
          expect(cb[ChessPosition.new(row, column)] == chess_piece[color])
        end
      end
    end
  end

  describe '#[]' do
    it 'returns object at position' do
      grid = Chessboard.new
      expect(grid[ChessPosition.from_s('a1')]).to eql(nil)
    end
  end

  describe '#each_chess_piece_with_pos' do
    it 'returns objects stored in grid with their positions' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('e4')] = Pawn.white # any object
      grid[ChessPosition.from_s('b6')] = 7
      grid[ChessPosition.from_s('g3')] = [] # any object
      expect(grid.each_chess_piece_with_pos.count).to eql(3)
    end
  end

  describe '#each_chess_piece' do
    it 'returns objects stored in grid' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('e4')] = Pawn.white # any object
      grid[ChessPosition.from_s('b6')] = 7
      grid[ChessPosition.from_s('g3')] = [] # any object
      expect(grid.each_chess_piece.count).to eql(3)
    end
  end

  describe '#find_pos' do
    it 'returns the ChessPosition of the first found chess piece' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('g5')] = Pawn.white
      expect(grid.find_pos(Pawn)).to eql(ChessPosition.from_s('g5'))
    end

    it 'returns nil if not found' do
      expect(Chessboard.new.find_pos(Pawn)).to eql(nil)
    end

    it 'returns nil there is a figure of the same class but different color' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('g5')] = Pawn.white
      expect(grid.find_pos(Pawn, :black)).to eql(nil)
    end
  end

  describe '#check?' do
    it 'returns true if king is under attack' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('e1')] = King.white
      grid[ChessPosition.from_s('e8')] = Queen.black
      expect(grid.check?(:white)).to eql(true)
    end

    it 'returns false if king is under attack by a chess piece of the same color' do
      grid = Chessboard.new
      grid[ChessPosition.from_s('e1')] = King.white
      grid[ChessPosition.from_s('e8')] = Queen.white
      expect(grid.check?(:white)).to eql(false)
    end
  end

  describe '#==' do
    it 'returns true if two different Chessboard objects contain same chess piece pattern' do
      grid1 = Chessboard.new
      grid1[ChessPosition.from_s('e1')] = King.white
      grid1[ChessPosition.from_s('b6')] = Queen.black

      grid2 = Chessboard.new
      grid2[ChessPosition.from_s('e1')] = King.white
      grid2[ChessPosition.from_s('b6')] = Queen.black

      expect(grid1).to eq(grid2)
    end

    it 'returns false if two different Chessboard objects contain different chess piece patterns' do
      grid1 = Chessboard.new
      grid1[ChessPosition.from_s('e1')] = King.white
      grid1[ChessPosition.from_s('b6')] = Queen.white

      grid2 = Chessboard.new
      grid2[ChessPosition.from_s('e1')] = King.white
      grid2[ChessPosition.from_s('b6')] = Queen.black

      expect(grid1 == grid2).to eq(false)
    end
  end

  describe '#copy' do
    it 'returns a copy of the Chessboard object' do
      grid1 = Chessboard.new
      grid1[ChessPosition.from_s('a5')] = King.black
      grid1[ChessPosition.from_s('g2')] = Queen.white

      grid2 = grid1.clone

      expect(grid1).to eq(grid2)
    end
  end

  describe '#attack_cells_from' do
    it 'returns the same array as ChessPiece#attack_cells' do
      cb = Chessboard.new
      cpos = ChessPosition.from_s('e2')
      cb[cpos] = Pawn.white

      moves1 = cb.attack_cells_from(cpos)
      moves2 = Pawn.white.attack_cells(cpos, cb)

      expect(moves1).to eql(moves2)
    end
  end

  describe '#allowed_moves_from' do
    it 'returns the same array as ChessPiece#allowed_moves' do
      cb = Chessboard.new
      cpos = ChessPosition.from_s('e7')
      cb[cpos] = Pawn.black

      moves1 = cb.attack_cells_from(cpos)
      moves2 = Pawn.black.attack_cells(cpos, cb)

      expect(moves1).to eql(moves2)
    end
  end
end
