

# Container of 64 spaces for chess figures
class Chessboard
  def self.decode_pos(str)
    raise 'expected string' unless str.is_a?(String)
    raise "invalid position: #{str}" unless str =~ /^[a-h][1-8]$/
    [str[0].ord - 'a'.ord, str[1].to_i - 1]
  end

  def self.encode_pos(array)
    raise 'expected array' unless array.is_a?(Array)
    raise "invalid position #{array}" unless array.size == 2 && array[0].between?(0, 7) && array[1].between?(0, 7)
    [(array[0] + 'a'.ord).chr, (array[1] + 1).to_s].join
  end
end
