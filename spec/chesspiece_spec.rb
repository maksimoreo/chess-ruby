require './lib/chesspieces/chesspiece'
require './lib/chesspieces/pawn'
require './lib/chesspieces/rook'
require './lib/chesspieces/king'
require './lib/chessboard'

describe ChessPiece do
  describe '#allowed_moves' do
    it 'returns all allowed moves for a chess piece' do
      moves = Pawn.white.allowed_moves(ChessPosition.from_s('e2'), Chessboard.new)
      expect(moves.size).to eql(2)
    end

    it 'returns 0 moves' do
      cb = Chessboard.new
      cb.place_chess_piece(King.white, ChessPosition.from_s('b2'))
      cb.place_chess_piece(Pawn.white, ChessPosition.from_s('d2'))
      cb.place_chess_piece(Rook.black, ChessPosition.from_s('g2'))

      moves = Pawn.white.allowed_moves(ChessPosition.from_s('d2'), cb)

      expect(moves.size).to eql(0)
    end
  end
end
