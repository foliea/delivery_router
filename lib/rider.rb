class Rider
  attr_reader :id, :speed, :x, :y

  def initialize(id:, speed:, x:, y:)
    @id    = id
    @speed = speed
    @x     = x
    @y     = y
    @order = nil
  end

  def dispatch!(order)
    @order = order

    @order.mark_as_dispatched_by!(self)
  end

  def dispatched?
    !order.nil?
  end

  def dispatching_order?(order)
    @order == order
  end

  def cancel_dispatching
    @order = nil
  end

  def route
    return [] unless dispatched?

    [order.restaurant, order.customer]
  end

  private

  attr_reader :order
end
