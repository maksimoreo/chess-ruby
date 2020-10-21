module ChessPieceSingleton
  @white = nil
  @black = nil

  def white
    if @white.nil?
      @white = self.new(:white)
    end
    @white
  end

  def black
    if @black.nil?
      @black = self.new(:black)
    end
    @black
  end
end
