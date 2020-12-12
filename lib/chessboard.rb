require_relative 'chess_position'
require_relative 'chesspieces/chesspiece'
require_relative 'chesspieces/king'
require_relative 'chesspieces/queen'
require_relative 'chesspieces/rook'
require_relative 'chesspieces/bishop'
require_relative 'chesspieces/knight'
require_relative 'chesspieces/pawn'
require 'json'

# Container of 64 spaces for chess pieces
# Allows indexing by ChessPosition object
class Chessboard
  protected

  attr_reader :board

  public

  attr_reader :info

  def self.default_chessboard
    cb = Chessboard.new

    # Pawns
    (0..7).each do |j|
      cb[ChessPosition.new(1, j)] = Pawn.white
      cb[ChessPosition.new(6, j)] = Pawn.black
    end

    # Other chess pieces
    [[0, :white], [7, :black]].each do |row, color|
      [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |chess_piece, column|
        cb[ChessPosition.new(row, column)] = chess_piece[color]
      end
    end

    cb
  end

  def self.from_json(str)
    cb = Chessboard.new
    cb.from_json(str)
    cb
  end

  # Creates an empty chess board
  def initialize
    @board = Array.new(64)

    @info = {
      white: {
        castling: {
          queenside: true, kingside: true
        }
      },
      black: {
        castling: {
          queenside: true, kingside: true
        }
      }
    }
  end

  def initialize_copy(original)
    @board = original.board.dup
  end

  def to_json
    board = @board.map { |chess_piece| chess_piece.nil? ? ' ' : [chess_piece.name, chess_piece.color] }
    { board: board, info: @info }.to_json
  end

  def from_json(str)
    hash = JSON.parse(str, { symbolize_names: true })
    @info = hash[:info]
    @board = hash[:board].map do |(chess_piece_name, color)|
      chess_piece_table = { 'Pawn' => Pawn, 'Knight' => Knight, 'Bishop' => Bishop,
        'Rook' => Rook, 'Queen' => Queen, 'King' => King }
      chess_piece_class = chess_piece_table[chess_piece_name]
      chess_piece_class.nil? ? nil : chess_piece_class[color.to_sym]
    end
  end

  def to_a
    @board.clone
  end

  def to_two_dimensional_array
    Array.new(8) { |row| Array.new(8) { |column| @board[row * 8 + column] } }
  end

  def ==(other)
    @board == other.board && @info == other.info
  end

  def board_eq?(other)
    @board == other.board
  end

  def [](position)
    @board[position.i * 8 + position.j]
  end

  def []=(position, object)
    @board[position.i * 8 + position.j] = object
  end

  def reposition(from, to)
    self[to] = self[from]
    self[from] = nil
  end

  def move(chess_move)
    self[chess_move.from].perform_chess_move(chess_move, self)
  end

  def can_move_or_take?(pos, color)
    self[pos].nil? || self[pos].color != color
  end

  def cell_empty?(pos)
    self[pos].nil?
  end

  def check?(color)
    king_pos = find_pos(King, color)
    cell_under_attack?(king_pos, ChessPiece.opposite_color(color))
  end

  def cell_under_attack?(check_cell, by_color)
    each_chess_piece_with_pos.any? do |chess_piece, pos|
      chess_piece.color == by_color && chess_piece.attack_cells(pos, self).include?(check_cell)
    end
  end

  # if color is :white or :black, returns each chess piece of specified color
  # if color is nil returns all chess pieces
  def each_chess_piece(color = nil)
    return to_enum(:each_chess_piece, color) unless block_given?
    @board.each do |cell|
      if !cell.nil? && (color.nil? || cell.color == color)
        yield(cell)
      end
    end
  end

  def each_chess_piece_with_pos(color = nil)
    return to_enum(:each_chess_piece_with_pos, color) unless block_given?
    @board.each_with_index do |cell, index|
      if !cell.nil? && (color.nil? || cell.color == color)
        yield(cell, ChessPosition.from_i(index))
      end
    end
  end

  def each_that_attacks(attack_pos, color = nil)
    return to_enum(:each_that_attacks, attack_pos, color) unless block_given?
    each_chess_piece_with_pos(color) do |piece, from_pos|
      yield(piece, from_pos) if piece.attack_cells(from_pos, self).include?(attack_pos)
    end
  end

  def find_pos(chess_piece_class, color = nil)
    index = @board.find_index do |cell|
      !cell.nil? && cell.class == chess_piece_class && (color.nil? || cell.color == color)
    end
    index.nil? ? nil : ChessPosition.from_i(index)
  end

  def attack_cells_from(pos)
    self[pos].attack_cells(pos, self)
  end

  def available_moves_from(pos)
    self[pos].available_moves(pos, self)
  end

  def allowed_cells_from(pos)
    self[pos].allowed_cells(pos, self)
  end

  def allowed_moves_from(pos)
    self[pos].allowed_moves(pos, self)
  end

  # def allowed_moves(color)
  #   @board.each_with_index.reduce({}) do |moves, (chess_piece, index)|
  #     if !chess_piece.nil? && chess_piece.color == color
  #       pos = ChessPosition.from_i(index)
  #       additional_moves = chess_piece.allowed_moves(pos, self)
  #       unless additional_moves.empty?
  #         moves[pos] = additional_moves
  #       end
  #     end
  #     moves
  #   end
  # end

  def allowed_moves(color)
    moves = []
    each_chess_piece_with_pos(color) do |chess_piece, pos|
      moves.push(*chess_piece.allowed_moves(pos, self))
    end
    moves
  end
end
