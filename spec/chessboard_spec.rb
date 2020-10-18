#spec/chessboard_spec.rb
require './lib/chessboard'
require './lib/chesspieces/chesspiece'
require './lib/chesspieces/pawn.rb'

describe Chessboard do
  describe '#chess_piece_at' do
    it 'returns nil if no chess piece was placed' do
      chessboard = Chessboard.new
      expect(chessboard.chess_piece_at(ChessPosition.from_s('a2'))).to eql(nil)
    end

    it 'returns chess piece that was placed here' do
      chessboard = Chessboard.new
      #chess_piece = ChessPiece.new('Some chess piece', :black)
      chess_piece = Pawn.white
      cpos = ChessPosition.from_s('e7')
      chessboard.place_chess_piece(chess_piece, cpos)
      expect(chessboard.chess_piece_at(cpos)).to eql(chess_piece)
    end
  end

  describe '#place_chess_piece' do
    it 'places a chess piece on the board' do
      chessboard = Chessboard.new
      chess_piece = Pawn.black
      cpos = ChessPosition.from_s('e7')
      chessboard.place_chess_piece(chess_piece, cpos)
      expect(chessboard.chess_piece_at(cpos)).to eql(chess_piece)
    end

    it 'fails when try to place object that is not of type ChessPiece' do
      chessboard = Chessboard.new
      def_not_a_chess_piece = 7
      cpos = ChessPosition.from_s('e7')
      expect {
        chessboard.place_chess_piece(def_not_a_chess_piece, cpos)
      }.to raise_error(RuntimeError)
    end
  end
end
