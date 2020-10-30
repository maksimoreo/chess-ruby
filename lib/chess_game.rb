# frozen_string_literal: true

require_relative 'chessboard'
require_relative 'chess_position'

# Holds information about chess game
# (chessboard, history, castlings)
class ChessGame
  class PlayerInfo
    attr_reader :player, :color

    def initialize(player, color, id)
      @player = player
      @color = color
      @id = id
    end

    def move(chessboard)
      @player.move(chessboard)
    end
  end

  attr_reader :state

  # Creates an empty chessboard
  def initialize(player1, player2)
    @chessboard = Chessboard.default_chessboard
    @player1 = PlayerInfo.new(player1, :white, 1)
    @player2 = PlayerInfo.new(player2, :black, 2)

    @current_player = @player1
    @state = :playing # :playing, :draw, :p1, :p2
  end

  def play
    loop do
      if @chessboard.allowed_moves(@current_player.color).empty?
        if @chessboard.check?(@current_player.color)
          @state = @current_player.id == 1 ? :p2 : :p1
        else
          @state = :draw
        end

        break
      else
        play_one_move
      end
    end

    @state
  end

  def play_one_move
    allowed_moves = @chessboard.allowed_moves(@current_player.color)

    (1..5).each do |attempt_i|
      move = @player1.move(@chessboard.clone)

      # TODO: check if player wants a draw or to surrender

      if allowed_moves.key?(move[:from]) && allowed_moves[move[:from]].include?(move[:to])
        @chessboard.move(move)
        break
      end
    end

    @current_player = @current_player.color == @player1.color ? @player2 : @player1
  end

  def winner
    case @state
    when :p1
      @player1.player
    when :p2
      @player2.player
    else
      nil
    end
  end
end
