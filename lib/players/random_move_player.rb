require_relative 'player'

class RandomMovePlayer < Player
  def move(chessboard)
    all_moves = []
    chessboard.allowed_moves(@color).each_pair do |from, moves_from|
      moves_from.each do |to|
        all_moves << { from: from, to: to }
      end
    end

    all_moves.sample
  end
end
