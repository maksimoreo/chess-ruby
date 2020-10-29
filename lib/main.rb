require_relative 'chess_game'
require_relative 'players/human_player'

player1 = HumanPlayer.new('Red')
player2 = HumanPlayer.new('Cyan')

game = ChessGame.new(player1, player2)

game.play
