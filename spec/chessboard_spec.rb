require './lib/chessboard'
require './lib/chesspieces/pawn'
require './lib/chesspieces/queen'

describe Chessboard do
  describe '.default_chessboard' do
    it 'returns default chessboard' do
      cb = Chessboard.default_chessboard

      # Other chess pieces
      [[0, :white], [7, :black]].each do |row, color|
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |chess_piece, column|
          expect(cb[ChessPosition.new(row, column)] == chess_piece[color])
        end
      end
    end
  end

  describe '#[]' do
    it 'returns object at position' do
      cb = Chessboard.new
      expect(cb[ChessPosition.from_s('a1')]).to eql(nil)
    end
  end

  describe '#each_chess_piece_with_pos' do
    it 'returns objects stored in cb with their positions' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('e4')] = Pawn.white # any object
      cb[ChessPosition.from_s('b6')] = 7
      cb[ChessPosition.from_s('g3')] = [] # any object
      expect(cb.each_chess_piece_with_pos.count).to eql(3)
    end
  end

  describe '#each_chess_piece' do
    it 'returns objects stored in cb' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('e4')] = Pawn.white # any object
      cb[ChessPosition.from_s('b6')] = 7
      cb[ChessPosition.from_s('g3')] = [] # any object
      expect(cb.each_chess_piece.count).to eql(3)
    end
  end

  describe '#find_pos' do
    it 'returns the ChessPosition of the first found chess piece' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('g5')] = Pawn.white
      expect(cb.find_pos(Pawn)).to eql(ChessPosition.from_s('g5'))
    end

    it 'returns nil if not found' do
      expect(Chessboard.new.find_pos(Pawn)).to eql(nil)
    end

    it 'returns nil there is a figure of the same class but different color' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('g5')] = Pawn.white
      expect(cb.find_pos(Pawn, :black)).to eql(nil)
    end
  end

  describe '#check?' do
    it 'returns true if king is under attack' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('e1')] = King.white
      cb[ChessPosition.from_s('e8')] = Queen.black
      expect(cb.check?(:white)).to eql(true)
    end

    it 'returns false if king is under attack by a chess piece of the same color' do
      cb = Chessboard.new
      cb[ChessPosition.from_s('e1')] = King.white
      cb[ChessPosition.from_s('e8')] = Queen.white
      expect(cb.check?(:white)).to eql(false)
    end
  end

  describe '#==' do
    it 'returns true if two different Chessboard objects contain same chess piece pattern' do
      cb1 = Chessboard.new
      cb1[ChessPosition.from_s('e1')] = King.white
      cb1[ChessPosition.from_s('b6')] = Queen.black

      cb2 = Chessboard.new
      cb2[ChessPosition.from_s('e1')] = King.white
      cb2[ChessPosition.from_s('b6')] = Queen.black

      expect(cb1).to eq(cb2)
    end

    it 'returns false if two different Chessboard objects contain different chess piece patterns' do
      cb1 = Chessboard.new
      cb1[ChessPosition.from_s('e1')] = King.white
      cb1[ChessPosition.from_s('b6')] = Queen.white

      cb2 = Chessboard.new
      cb2[ChessPosition.from_s('e1')] = King.white
      cb2[ChessPosition.from_s('b6')] = Queen.black

      expect(cb1 == cb2).to eq(false)
    end
  end

  describe '#copy' do
    it 'returns a copy of the Chessboard object' do
      cb1 = Chessboard.new
      cb1[ChessPosition.from_s('a5')] = King.black
      cb1[ChessPosition.from_s('g2')] = Queen.white

      cb2 = cb1.clone

      expect(cb1).to eq(cb2)
    end
  end

  describe '#attack_cells_from' do
    it 'returns the same array as ChessPiece#attack_cells' do
      cb = Chessboard.new
      cpos = ChessPosition.from_s('e2')
      cb[cpos] = Pawn.white

      moves1 = cb.attack_cells_from(cpos)
      moves2 = Pawn.white.attack_cells(cpos, cb)

      expect(moves1).to eql(moves2)
    end
  end

  describe '#allowed_moves_from' do
    it 'returns the same array as ChessPiece#allowed_moves' do
      cb = Chessboard.new
      cpos = ChessPosition.from_s('e7')
      cb[cpos] = Pawn.black

      moves1 = cb.attack_cells_from(cpos)
      moves2 = Pawn.black.attack_cells(cpos, cb)

      expect(moves1).to eql(moves2)
    end
  end

  describe '#allowed_moves' do
    # it 'returns all moves for specified color' do
    #   moves = Chessboard.default_chessboard.allowed_moves(:white)
    #   expect(moves.keys.size).to eql(10) # 8 for pawns, 2 for knights
    #   expect(moves.values.flatten.size).to eql(20) # 16 for pawns, 4 for knights
    # end

    it 'returns all 20 moves from default chessboard' do
      moves = Chessboard.default_chessboard.allowed_moves(:white)
      chess_pieces_n = moves.map { |move| move.from }.uniq.size
      expect(chess_pieces_n).to eql(10) # 8 for pawns, 2 for knights
      expect(moves.size).to eql(20) # 16 for pawns, 4 for knights
    end
  end

  describe '#to_a' do
    it 'returns one dimensional array' do
      cb = Chessboard.default_chessboard
      cb.to_a.each_with_index do |cell, index|
        expect(cell == cb[ChessPosition.from_i(index)])
      end
    end
  end

  describe '#to_two_dimensional_array' do
    it 'returns one dimensional array' do
      cb = Chessboard.default_chessboard
      cb.to_two_dimensional_array.each_with_index do |row, row_index|
        row.each_with_index do |cell, column_index|
          expect(cell == cb[ChessPosition.new(row_index, column_index)])
        end
      end
    end
  end

  describe '#from_json' do
    it 'creates new chessboard from json string' do
      cb1 = Chessboard.default_chessboard
      json_string = cb1.to_json
      cb2 = Chessboard.from_json(json_string)
      expect(cb2).to eq(cb1)
    end
  end

  describe '#each_that_attacks' do
    it 'returns pieces that attack specified cell' do
      cb = Chessboard.new
      pawn1_pos = ChessPosition.from_s('d3')
      cb[pawn1_pos] = Pawn.white
      pawn2_pos = ChessPosition.from_s('c4')
      cb[pawn2_pos] = Pawn.white
      knight_pos = ChessPosition.from_s('e3')
      cb[knight_pos] = Knight.white
      bishop_pos = ChessPosition.from_s('f3')
      cb[bishop_pos] = Bishop.white
      rook_pos = ChessPosition.from_s('g5')
      cb[rook_pos] = Rook.white
      result = []
      cb.each_that_attacks(ChessPosition.from_s('d5')) { |piece, pos| result << [piece, pos] }
      expect(result).to contain_exactly([Pawn.white, pawn2_pos], [Knight.white, knight_pos], [Bishop.white, bishop_pos], [Rook.white, rook_pos])
    end
  end
end
