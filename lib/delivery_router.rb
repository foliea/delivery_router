Customer = Struct.new(:id, :x, :y)

Restaurant = Struct.new(:id, :cooking_time, :x, :y)

Rider = Struct.new(:id, :speed, :x, :y)

class DeliveryRouter
  def initialize(restaurants, customers, riders)
    @restaurants = restaurants
    @customers   = customers
    @riders      = riders
  end

  def add_order(customer:, restaurant:)

  end

  def clear_orders(customer:)

  end

  def route(rider:)
    []
  end

  def delivery_time(customer:)
    60
  end
end
