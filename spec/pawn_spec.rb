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

  describe '#name' do
    it "retuns 'Pawn'" do
      expect(Pawn.white.name).to eql('Pawn')
    end

    it 'always returns the same string object' do
      expect(Pawn.white.name).to equal(Pawn.white.name)
    end

    it 'white and black #name methods return the same string object' do
      expect(Pawn.white.name).to equal(Pawn.black.name)
    end
  end

  describe '.name' do
    it "returns 'Pawn'" do
      expect(Pawn.name).to eql('Pawn')
    end

    it 'always returns the same string object' do
      expect(Pawn.name).to equal(Pawn.name)
    end

    it 'returns same string object as #name method' do
      expect(Pawn.name).to equal(Pawn.white.name)
    end
  end
end
