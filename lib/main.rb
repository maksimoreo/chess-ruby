require_relative 'chess_game'
require_relative 'players/human_player'
require_relative 'players/random_move_player'

player1 = HumanPlayer.new('Red')
player2 = RandomMovePlayer.new('Cyan')

game = ChessGame.new(player1, player2)

game.play
