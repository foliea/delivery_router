class Restaurant
  attr_reader :id, :cooking_time, :x, :y

  def initialize(id:, cooking_time:, x:, y:)
    @id           = id
    @cooking_time = cooking_time
    @x            = x
    @y            = y
  end
end
