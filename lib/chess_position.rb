

class ChessPosition
  attr_reader :i, :j

  # Returns nil if incorrect string
  def self.from_s(str)
    str = str.downcase

    if str =~ /^[a-h][1-8]$/
      ChessPosition.new(str[0].ord - 'a'.ord, str[1].to_i - 1)
    else
      nil
    end
  end

  # Returns nil if incorrect array
  def self.from_a(array)
    if array.size == 2 && array.all? { |e| e.between?(0, 7) }
      ChessPosition.new(array[0], array[1])
    else
      nil
    end
  end

  def initialize(i, j)
    raise "invalid position: #{i}, #{j}" unless i.between?(0, 7) && j.between?(0, 7)

    @i = i
    @j = j
  end

  def to_s
    "#{'a'.ord + i}#{j}"
  end

  def to_a
    [i, j]
  end

  def to_h
    {i: i, j: j}
  end

  def up
    (i + 1).between?(0, 7) ? ChessPosition.new(i + 1, j) : nil
  end

  def down
    (i - 1).between?(0, 7) ? ChessPosition.new(i - 1, j) : nil
  end

  def right
    (j + 1).between?(0, 7) ? ChessPosition.new(i, j + 1) : nil
  end

  def left
    (j - 1).between?(0, 7) ? ChessPosition.new(i, j - 1) : nil
  end
end
