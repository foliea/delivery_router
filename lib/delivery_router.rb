require 'customer'
require 'restaurant'
require 'rider'
require 'order'

class DeliveryRouter
  def initialize(restaurants, customers, riders)
    @restaurants = restaurants
    @customers   = customers
    @riders      = riders
    @orders      = []
  end

  def add_order(customer:, restaurant:)
    order = Order.new(
      restaurant: restaurant_by_id(restaurant), customer: customer_by_id(customer)
    )
    optimum_rider_for(order).dispatch!(order)

    orders << order
  end

  def clear_orders(customer:)
    order = order_by_customer_id(customer)

    return unless order

    orders.delete(order)

    riders.find { |rider| rider.dispatching_order?(order).cancel_dispatching! }
  end

  def route(rider:)
    rider_by_id(rider).route
  end

  def delivery_time(customer:)
    order_by_customer_id(customer).delivery_time
  end

  private

  attr_reader :restaurants, :customers, :riders, :orders

  def restaurant_by_id(id)
    restaurants.find { |restaurant| restaurant.id == id }
  end

  def rider_by_id(id)
    riders.find { |rider| rider.id == id }
  end

  def customer_by_id(id)
    customers.find { |customer| customer.id == id }
  end

  def order_by_customer_id(id)
    orders.find { |order| order.customer.id == id }
  end

  def riders_available
    riders.reject { |rider| rider.dispatched? }
  end

  def optimum_rider_for(order)
    # Sort first riders by time required to complete the order.
    riders_infos = riders_available.map do |rider|
      { rider: rider, time: order.delivery_time_for(rider), distance: order.distance_for(rider) }
    end.sort_by { |r| r[:time] }
    # Sort then riders by distance required to reach to the customer position.
    riders_infos.select do |infos|
      infos[:time] == riders_infos.first[:time]
    end.sort_by { |r| r[:distance] }.first[:rider]
  end
end
