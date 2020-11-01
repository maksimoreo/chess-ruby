require_relative 'chessboard'
require_relative 'cmd_interface'
require_relative 'players/random_move_player'

def start_game(chessboard)
  input = Console.ask('Choose players:', 'Player vs Player', 'Player vs Computer', 'Computer vs Computer')

  case input
  when 0 # pvp
    game_loop(chessboard, nil, nil)
  when 1 # pvc
    Console.ask_color == :white ? game_loop(chessboard, nil, RandomMovePlayer.new(:black)) : game_loop(RandomMovePlayer.new(:white), nil)
  when 2 # cvc
  end
end

def game_loop(chessboard, player1, player2)
  players = { white: player1, black: player2 }
  chess_game = { current_color: :white, state: :playing, chessboard: chessboard }
  current_player = ->() { players[chess_game[:current_color]] }

  loop do
    puts "#{chess_game[:current_color]} plays:"
    Console.print_chessboard(chess_game[:chessboard])

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
  file_name = Console.ask_file_name('Please enter a file name to load chessboard from:')

  return nil if file_name == ''

  return Chessboard.from_json(File.read(file_name))
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
  file_name = Console.ask_file_name('Please enter a file name to save the chessboard in:')
  File.write(file_name, chessboard.to_json)
  puts "Chessboard is saved in: #{file_name}"

end

puts 'Welcome to Chess!'
loop do
  input = Console::ask('Menu:', 'Start new game', 'Load game', 'About', 'Exit')

  case input
  when 0 # Start new game
    start_game(Chessboard.default_chessboard)
  when 1 # Load game
    chess_game = load_chessboard
    next if chess_game.nil?
    start_game(chess_game)
  when 2 # About
    puts 'Chess game v999 2020-10-01'
  when 3 # exit
    break
  end
end

puts 'Bye!'
