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

  describe '#attack_cells' do
    it 'returns 2 attack cells when placed somewhere in the middle of the chessboard' do
      attack_cells = Pawn.white.attack_cells(ChessPosition.from_s('d2'), Chessboard.new)
      expect(attack_cells.size).to eql(2)
    end

    it 'returns 1 attack cells when placed near the edge of the chessboard' do
      attack_cells = Pawn.white.attack_cells(ChessPosition.from_s('a7'), Chessboard.new)
      expect(attack_cells.size).to eql(1)
    end

    it 'returns 0 attack cells when placed near the top of the chessboard' do
      attack_cells = Pawn.white.attack_cells(ChessPosition.from_s('f8'), Chessboard.new)
      expect(attack_cells.size).to eql(0)
    end
  end

  describe '#available_moves' do
    it 'returns 2 moves from start position' do
      moves = Pawn.white.available_moves(ChessPosition.from_s('e2'), Chessboard.new)
      expect(moves.size).to eql(2)
    end

    it 'returns 1 moves from start position when blocked at 4th row' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('b4')] = Pawn.white
      moves = Pawn.white.available_moves(ChessPosition.from_s('b2'), cb)
      expect(moves.size).to eql(1)
    end

    it 'returns 0 moves from start position when blocked at 3th row' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('g3')] = Pawn.white
      moves = Pawn.white.available_moves(ChessPosition.from_s('g2'), cb)
      expect(moves.size).to eql(0)
    end

    it 'returns 3 from start position when can capture' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('b3')] = Pawn.black
      moves = Pawn.white.available_moves(ChessPosition.from_s('c2'), cb)
      expect(moves.size).to eql(3)
    end
  end
end
