require './lib/chesspieces/king'
require './lib/chesspieces/knight'
require './lib/chessboard'

describe King do
  describe '#available_moves' do
    it 'returns 8 moves when placed in the center of the chessboard' do
      moves = King.white.available_moves(ChessPosition.from_s('e4'), Chessboard.new)
      expect(moves.size).to eql(8)
    end

    it 'returns 3 moves when placed in the corner of the chessboard' do
      moves = King.white.available_moves(ChessPosition.from_s('a1'), Chessboard.new)
      expect(moves.size).to eql(3)
    end

    it 'returns 3 moves' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('a2')] = Knight.white
      cb[ChessPosition.from_s('b1')] = Knight.white
      moves = King.black.available_moves(ChessPosition.from_s('a1'), cb)
      expect(moves.size).to eql(3)
    end

    it 'returns 1 move' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('a2')] = Knight.white
      cb[ChessPosition.from_s('b1')] = Knight.black
      cb[ChessPosition.from_s('b2')] = Knight.black
      moves = King.black.available_moves(ChessPosition.from_s('a1'), cb)
      expect(moves.size).to eql(1)
    end

    it 'returns 0 moves' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('a2')] = Knight.black
      cb[ChessPosition.from_s('b1')] = Knight.black
      cb[ChessPosition.from_s('b2')] = Knight.black
      moves = King.black.available_moves(ChessPosition.from_s('a1'), cb)
      expect(moves.size).to eql(0)
    end
  end
end
