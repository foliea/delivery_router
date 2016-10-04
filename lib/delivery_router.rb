class Customer
  attr_reader :id, :x, :y

  def initialize(id:, x:, y:)
    @id = id
    @x = x
    @y = y
  end
end

class Restaurant
  attr_reader :id, :cooking_time, :x, :y

  def initialize(id:, cooking_time:, x:, y:)
    @id = id
    @cooking_time = cooking_time
    @x = x
    @y = y
  end
end

class Rider
  attr_reader :id, :speed, :x, :y

  def initialize(id:, speed:, x:, y:)
    @id = id
    @speed = speed
    @x = x
    @y = y
  end
end

class Order
  attr_reader :customer_id, :restaurant_id

  def initialize(customer_id:, restaurant_id:)
    @customer_id   = customer_id
    @restaurant_id = restaurant_id
  end
end

class DeliveryRouter
  def initialize(restaurants, customers, riders)
    @restaurants = restaurants
    @customers   = customers
    @riders      = riders
    @orders      = []
  end

  def add_order(customer:, restaurant:)
    orders << Order.new(customer_id: customer, restaurant_id: restaurant)
  end

  def clear_orders(customer:)
    orders.reject! { |order| order.customer_id == customer}
  end

  def route(rider:)
    order = find_order(rider: riders.find { |r| r.id == rider })

    return [] unless order
    [
      restaurants.find { |r| r.id == order.restaurant_id },
      customers.find   { |c| c.id == order.customer_id   }
    ]
  end

  def delivery_time(customer:)
    order = orders.find { |o| o.customer_id == customer }

    riders.map do |rider|
      delivery_time_for(
        rider: riders.find { |r| r.id == rider.id }, order: order
      )
    end.min
  end

  private

  attr_reader :restaurants, :customers, :riders, :orders

  def find_order(rider:, exclude: [])
    exclude << rider.id

    order_times_for(rider: rider).each do |time, order|
      riders.reject { |r| exclude.include?(r.id) }.each do |r|
        return route unless find_order(rider: r, exclude: exclude) == order
      end
    end
    nil
  end

  def order_times_for(rider:)
    orders_times = {}

    orders.each do |order|
      time = delivery_time_for(rider: rider, order: order)

      orders_times[time] = order
    end
    orders_times
  end

  def delivery_time_for(rider:, order:)
    restaurant = restaurants.find { |r| r.id == order.restaurant_id }

    customer = customers.find { |c| c.id == order.customer_id }

    time_rider_restaurant = time_between(rider, restaurant, speed: rider.speed)

    if restaurant.cooking_time > time_rider_restaurant
      time_rider_restaurant = restaurant.cooking_time
    end
    time_rider_restaurant + time_between(restaurant, customer, speed: rider.speed)
  end

  def time_between(a, b, speed:)
    distance(a, b) * 60 / speed
  end

  def distance(a, b)
    Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2)
  end
end
