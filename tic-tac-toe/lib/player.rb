class Player
  attr_accessor :symbol, :name

  def initialize(symbol = "", name = "")
    @symbol = symbol
    @name = name
  end
end
