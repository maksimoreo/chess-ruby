require './lib/chesspieces/pawn'
require './lib/chessboard'
require './lib/chess_position'

describe Pawn do
  describe '.white' do
    it 'returns white instance of Pawn' do
      chess_piece = Pawn.white
      expect(chess_piece).to have_attributes(name: 'Pawn', color: :white)
    end

    it 'returns same object when called several times' do
      chess_piece_1 = Pawn.white
      chess_piece_2 = Pawn.white
      expect(chess_piece_1).to equal(chess_piece_2)
    end
  end
end
