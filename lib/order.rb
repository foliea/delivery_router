class Order
  attr_reader :restaurant, :customer

  def initialize(restaurant:, customer:)
    @restaurant = restaurant
    @customer   = customer
  end

  def delivery_time
    delivery_time_for(dispatcher)
  end

  def delivery_time_for(rider)
    time_rider_to_restaurant(rider) #+ time_restaurant_customer(at: rider.speed)
  end

  def mark_as_dispatched_by!(rider)
    @dispatcher = rider
  end

  private

  attr_reader :dispatcher

  def time_rider_to_restaurant(rider)
    time_between(rider, restaurant, speed: rider.speed)
  end

  def time_restaurant_customer(at:)
    time_between(restaurant, customer, speed: at)
  end

  def time_between(a, b, speed:)
    distance(a, b) * 60 / speed
  end

  def distance(a, b)
    Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2)
  end
end
