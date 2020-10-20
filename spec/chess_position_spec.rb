#spec/chessboard_spec.rb
require './lib/chess_position'

describe ChessPosition do
  describe '.from_s' do
    it 'returns ChessPosition object converted from string' do
      cpos = ChessPosition.from_s('a1')
      expect(cpos.i).to eql(0)
      expect(cpos.j).to eql(0)
    end

    it 'returns ChessPosition object converted from string' do
      cpos = ChessPosition.from_s('e8')
      expect(cpos.i).to eql(4)
      expect(cpos.j).to eql(7)
    end

    it 'returns nil if string is incorrect' do
      cpos = ChessPosition.from_s('a9')
      expect(cpos).to eql(nil)
    end
  end

  describe '.from_a' do
    it 'returns ChessPosition object converted from array' do
      cpos = ChessPosition.from_a([0, 0])
      expect(cpos.i).to eql(0)
      expect(cpos.j).to eql(0)
    end

    it 'returns ChessPosition object converted from array' do
      cpos = ChessPosition.from_a([5, 2])
      expect(cpos.i).to eql(5)
      expect(cpos.j).to eql(2)
    end

    it 'returns nil if array is incorrect' do
      cpos = ChessPosition.from_a([8, 1])
      expect(cpos).to eql(nil)
    end
  end

  describe '.from_i' do
    it 'returns ChessPosition object converted from integer' do
      cpos = ChessPosition.from_i(17)
      expect(cpos.i).to eql(2)
      expect(cpos.j).to eql(1)
    end

    it 'returns nil if array is incorrect' do
      cpos = ChessPosition.from_i(64)
      expect(cpos).to eql(nil)
    end
  end
end
