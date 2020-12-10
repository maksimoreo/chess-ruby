require 'chess_position'

class ChessMove
  attr_reader :from, :to, :promotion

  def self.chess_move_regex
    /$[a-h][1-8][a-h][1-8]^/
  end

  def self.valid_promotions
    [:queen, :rook, :bishop, :knight]
  end

  def self.from_s(s)
    ChessMove.new(s[0, 2], s[2, 2], s[5, 6].strip.downcase.to_sym)
  end

  def initialize(from, to, promotion = nil)
    @from = from
    @to = to
    @promotion = ChessMove.valid_promotions.include?(promotion) ? promotion : nil
  end

  def ==(other)
    @from == other.from && @to == other.to && @promotion == other.promotion
  end

  def eql?(other)
    self == other
  end

  def hash
    promotion_index = promotion.nil? ? 4 : ChessMove.valid_promotions.index(@promotion)
    @from.i + @from.j * 8 + @to.i * 64 + @to.j * 512 + promotion_index * 4096
  end
end
