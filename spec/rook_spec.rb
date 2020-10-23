require './lib/chesspieces/rook'
require './lib/chessboard'

describe Rook do
  describe '#available_moves' do
    it 'returns 14 moves when placed in the center of the chessboard' do
      moves = Rook.white.available_moves(ChessPosition.from_s('e4'), Chessboard.new)
      expect(moves.size).to eql(14)
    end

    it 'returns 14 moves when placed in the corner of the chessboard' do
      moves = Rook.white.available_moves(ChessPosition.from_s('a1'), Chessboard.new)
      expect(moves.size).to eql(14)
    end

    it 'returns 3 moves' do
      cb = Chessboard.new
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('a3'))
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('b1'))
      moves = Rook.black.available_moves(ChessPosition.from_s('a1'), cb)
      expect(moves.size).to eql(3)
    end

    it 'returns 1 move' do
      cb = Chessboard.new
      cb.place_chess_piece(Rook.black, ChessPosition.from_s('d3'))
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('d5'))
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('c4'))
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('e4'))
      moves = Rook.white.available_moves(ChessPosition.from_s('d4'), cb)
      expect(moves.size).to eql(1)
    end

    it 'returns 0 moves (empty array)' do
      cb = Chessboard.new
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('a2'))
      cb.place_chess_piece(Rook.white, ChessPosition.from_s('b1'))
      moves = Rook.white.available_moves(ChessPosition.from_s('a1'), cb)
      expect(moves.size).to eql(0)
    end
  end
end
