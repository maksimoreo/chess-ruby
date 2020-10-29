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

      if allowed_moves.key?(move) && allowed_moves[move.from].include?(move.to)
        @chessboard.move(move.from, move.to)
        break
      end
    end

    @current_player = @current_player.color == @player1.color ? @player2 : @player1
  end

  # Returns chess piece or nil if cell is empty
  def chess_piece_at(position)
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)

    @chessboard[position]
  end

  # Places chess piece at specified position
  def place_chess_piece(chess_piece, position)
    unless chess_piece.class.ancestors.include?(ChessPiece)
      raise 'only ChessPiece objects or derived objects can be placed on ChessBoard'
    end
    raise 'expected ChessPosition object' unless position.is_a?(ChessPosition)
    raise 'cell is not empty' unless @chessboard[position].nil?

    @chessboard[position] = chess_piece
  end

  def allowed_moves(color)
    # all_available_moves = []
    # for each piece _p on the board
    #   if _color == _p.color
    #     _moves = get available moves
    #     for each move _move in _moves
    #       _new_board = try perform the move _move
    #       unless _new_board.is_check?(color)
    #         all_available_moves << _move
    # return all_available_moves
  end
end
