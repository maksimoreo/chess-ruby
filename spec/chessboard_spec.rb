#spec/chessboard_spec.rb
require './lib/chessboard'
require './lib/chesspiece'

describe Chessboard do
  describe '.decode_pos' do
    it 'decodes given string and returns array of two numbers' do
      expect(Chessboard.decode_pos('e7')).to eql([4, 6])
    end

    it "returns [0, 0] on 'a1'" do
      expect(Chessboard.decode_pos('a1')).to eql([0, 0])
    end

    it "returns [7, 7] on 'h8'" do
      expect(Chessboard.decode_pos('h8')).to eql([7, 7])
    end
  end

  describe '.encode_pos' do
    it 'encodes given array and returns a string' do
      expect(Chessboard.encode_pos([5, 3])).to eql('f4')
    end

    it "returns 'a1' on [0, 0]" do
      expect(Chessboard.encode_pos([0, 0])).to eql('a1')
    end

    it "returns 'h8' on [7, 7]" do
      expect(Chessboard.encode_pos([7, 7])).to eql('h8')
    end
  end

  describe '#chess_piece_at' do
    it 'returns nil if no chess piece was placed' do
      chessboard = Chessboard.new
      expect(chessboard.chess_piece_at('a2')).to eql(nil)
    end

    it 'returns chess piece that was placed here' do
      chessboard = Chessboard.new
      figure = ChessPiece.new('Some chess piece')
      chessboard.place_chess_piece(figure, 'e7')
      expect(chessboard.chess_piece_at('e7')).to eql(figure)
    end
  end

  describe '#place_chess_piece' do
    it 'places a chess piece on the board' do
      chessboard = Chessboard.new
      figure = ChessPiece.new('Some chess piece')
      chessboard.place_chess_piece(figure, 'e7')
      expect(chessboard.chess_piece_at('e7')).to eql(figure)
    end

    it 'fails when try to place object that is not of type ChessPiece' do
      chessboard = Chessboard.new
      def_not_a_chess_piece = 7
      expect {
        chessboard.place_chess_piece(def_not_a_chess_piece, 'e7')
      }.to raise_error(RuntimeError)
    end
  end
end
