require_relative 'player'

class HumanPlayer < Player
  class << self
    attr_reader :chess_piece_map_unicode
  end

  @chess_piece_map_unicode = {
    white: { King: "\u2654 ", Queen: "\u2655 ", Rook: "\u2656 ", Bishop: "\u2657 ", Knight: "\u2658 ", Pawn: "\u2659 " },
    black: { King: "\u265a ", Queen: "\u265b ", Rook: "\u265c ", Bishop: "\u265d ", Knight: "\u265e ", Pawn: "\u265f " },
    empty_white: "\u2591" * 2,
    empty_black: '  '
  }

  def self.print_chessboard(chessboard, cp_map = HumanPlayer.chess_piece_map_unicode)
    empty = ->(i, j) { (i + j).even? ? cp_map[:empty_white] : cp_map[:empty_black]}

    puts '  \\' + '_' * 16
    chessboard.to_two_dimensional_array.each_with_index.reverse_each do |row, row_index|
      row_string = row.each_with_index.map do |cell, column_index|
        cell.nil? ? empty.call(row_index, column_index) : cp_map[cell.color][cell.name.to_sym]
      end.join('')
      puts "#{row_index + 1} | #{row_string}"
    end
    puts '  \\' + '_' * 16
    puts "    #{(0..7).map { |j| (j + 'a'.ord).chr }.to_a.join(' ')}"
  end

  def initialize(name)
    super
  end

  def move(chessboard, color)
    puts "It's your turn, #{name}! You play for: #{color}."
    HumanPlayer.print_chessboard(chessboard)
    ask_move
  end

  private

  def ask_move
    puts 'Please enter a move (start cell letter, start cell number, destination cell letter, destination cell number):'
    move = {}

    loop do
      print '> '
      input = gets.chomp

      # TODO: also accept 'draw' and 'surrender'
      # TODO: also accept pawn promotion

      if input =~ /^([a-h][1-8]){2}$/
        move[:from] = ChessPosition.from_s(input[0..1])
        move[:to] = ChessPosition.from_s(input[2..3])
        break
      end
    end

    move
  end
end
