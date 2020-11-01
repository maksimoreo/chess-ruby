require_relative 'chess_game'
require_relative 'players/human_player'
require_relative 'players/random_move_player'

def ask(question, *options)
  puts question
  options.each_with_index { |option, index| puts "#{index + 1}. #{option}" }

  input = 0
  until input.between?(1, options.size)
    print "[1-#{options.size}] > "
    input = gets.chomp.to_i
  end

  input - 1
end

def ask_file_name(question)
  puts question
  print '> '
  # TODO: check regex
  # TODO: check if file exists
  gets.chomp
end

def ask_color
  ask('Choose color:', 'White', 'Black') == 0 ? :white : :black
end

def start_game(chessboard)
  input = ask('Choose players:', 'Player vs Player', 'Player vs Computer', 'Computer vs Computer')

  case input
  when 0 # pvp
    game_loop(chessboard, nil, nil)
  when 1 # pvc
    ask_color == :white ? game_loop(chessboard, RandomMovePlayer.new, nil) : game_loop(nil, RandomMovePlayer.new)
  when 2 # cvc
  end
end

def game_loop(chessboard, player1, player2)
  players = { white: player1, black: player2 }
  chess_game = { current_color: :white, state: :playing, chessboard: chessboard }
  current_player = ->() { players[chess_game[:current_color]] }

  loop do
    puts "#{chess_game[:current_color]} plays:"
    print_chessboard(chess_game[:chessboard])

    response = current_player.call.nil? ? process_input(chess_game) : current_player.call.move(chess_game[:chessboard])

    break unless chess_game[:state] == :playing

    allowed_moves = chess_game[:chessboard].allowed_moves(chess_game[:current_color])
    if allowed_moves.key?(response[:from]) && allowed_moves[response[:from]].include?(response[:to])
      chess_game[:chessboard].move(response)
      chess_game[:current_color] = ChessPiece.opposite_color(chess_game[:current_color])
    else
      chess_game[:state] = ChessPiece.opposite_color(chess_game[:current_color])
      break
    end
  end

  chess_game[:state]
end

def load_chessboard
  file_name = ask_file_name('Please enter a file name to load chessboard from:')

  return nil if file_name == ''

  return Chessboard.from_json(File.read(file_name))
end

module ChessPieceMaps
  class << self
    attr_reader :chess_piece_map_unicode
  end

  @chess_piece_map_unicode = {
    white: { King: "\u2654 ", Queen: "\u2655 ", Rook: "\u2656 ", Bishop: "\u2657 ", Knight: "\u2658 ", Pawn: "\u2659 " },
    black: { King: "\u265a ", Queen: "\u265b ", Rook: "\u265c ", Bishop: "\u265d ", Knight: "\u265e ", Pawn: "\u265f " },
    empty_white: "\u2591" * 2,
    empty_black: '  '
  }
end

def print_chessboard(chessboard, cp_map = ChessPieceMaps.chess_piece_map_unicode)
  empty = ->(i, j) { (i + j).even? ? cp_map[:empty_white] : cp_map[:empty_black]}

  puts '    ' + '_' * 18
  puts '   /' + ' ' * 18 + '\\'
  chessboard.to_two_dimensional_array.each_with_index.reverse_each do |row, row_index|
    row_string = row.each_with_index.map do |cell, column_index|
      cell.nil? ? empty.call(row_index, column_index) : cp_map[cell.color][cell.name.to_sym]
    end.join('')
    puts "#{row_index + 1} |  #{row_string}  |"
  end
  puts '   \\' + '_' * 18 + '/'
  puts "     #{(0..7).map { |j| (j + 'a'.ord).chr }.to_a.join(' ')}"
end

def process_input(chess_game)
  puts "Please enter a move ('stop' to stop the game, 'save' to save current state of the chessboard, 'surrender' to surrender, 'draw' to propose a draw):"
  loop do
    print '> '
    input = gets.chomp.downcase

    case input
    when 'stop', 'exit', 'quit', 'leave'
      chess_game[:state] = :stop
    when 'save'
      save_chessboard(chess_game[:chessboard])
      next
    when 'surrender'
      chess_game[:state] = chess_game[:current_color]
      return { surrender: true }
    when 'draw'
      return { draw: true }
    when /^([a-h][1-8]){2}/
      return { from: ChessPosition.from_s(input[0..1]), to: ChessPosition.from_s(input[2..3]) }
    else
      puts 'Invalid input!'
      next
    end

    break
  end

  false
end

def save_chessboard(chessboard)
  file_name = ask_file_name('Please enter a file name to save the chessboard in:')
  File.write(file_name, chessboard.to_json)
  puts "Chessboard is saved in: #{file_name}"

end

puts 'Welcome to Chess!'
loop do
  input = ask('Menu:', 'Start new game', 'Load game', 'About', 'Exit')

  case input
  when 0 # Start new game
    start_game(Chessboard.default_chessboard)
  when 1 # Load game
    chess_game = load_chessboard
    next if chess_game.nil?
    start_game(chess_game)
  when 2 # About
    puts 'About'
  when 3 # exit
    break
  end
end

puts 'Bye!'
