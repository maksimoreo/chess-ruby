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
      @player.move(chessboard, @color)
    end
  end

  attr_reader :state

  # Creates an empty chessboard
  def initialize(white_player, black_player)
    @chessboard = Chessboard.default_chessboard
    @players = { white: white_player, black: black_player }
    @current_color = :white
    @state = :playing # :playing, :draw, :white, :black
  end

  def current_player
    @players[@current_color]
  end

  def switch_player
    @current_color = @current_color == :white ? :black : :white
  end

  def play
    loop do
      if @chessboard.allowed_moves(@current_color).empty?
        if @chessboard.check?(@current_color)
          @state = @current_color
        else
          @state = :draw
        end

        break
      else
        puts "Now is #{current_player.name}'s turn"
        break unless play_one_move
      end
    end

    @state
  end

  def play_one_move
    allowed_moves = @chessboard.allowed_moves(@current_color)

    (1..5).each do |attempt_i|
      move = current_player.move(@chessboard.clone, @current_color)

      # TODO: check if player wants a draw or to surrender
      return false if move[:surrender]

      if allowed_moves.key?(move[:from]) && allowed_moves[move[:from]].include?(move[:to])
        @chessboard.move(move)
        break
      end
    end

    switch_player
    true
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
