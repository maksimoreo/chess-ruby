require './lib/chess_move'

describe ChessMove do
  describe '#new' do
    it "returns a move contructed from 'from' position and 'to' position" do
      from = ChessPosition.from_s('e2')
      to = ChessPosition.from_s('e4')
      move = ChessMove.new(from, to)
      expect(move.from).to eql(from)
      expect(move.to).to eql(to)
    end

    it 'also allows to specify pawn promotion' do
      from = ChessPosition.from_s('a1')
      to = ChessPosition.from_s('h8')
      move = ChessMove.new(from, to, :rook)
      expect(move.from).to eql(from)
      expect(move.to).to eql(to)
      expect(move.promotion).to eql(:rook)
    end
  end
end
