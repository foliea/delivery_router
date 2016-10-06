require 'order'

describe Order do
  let(:customer) { double(id: 1, x: 2, y: 3) }

  let(:restaurant) { double(id: 1, cooking_time: 10, x: 4, y: 5) }

  let(:order) { Order.new(restaurant: restaurant, customer: customer) }

  describe '#delivery_time' do
    subject { order.delivery_time }

    context 'when dispatched by a rider' do
      let(:rider) { double(id: 1, speed: 10, x: 1, y: 1) }

      before { order.mark_as_dispatched_by!(rider) }

      it 'is equal to the delivery time for this rider' do
        is_expected.to eq(order.delivery_time_for(rider))
      end
    end
  end

  describe '#delivery_time_for' do
    let(:rider) { double(x: 0, y: 0, speed: 10) }

    let(:customer) { double(x: 2, y: 2) }

    subject(:delivery_time) { order.delivery_time_for(rider) }

    context 'when rider time to get to the restaurant is below cooking time' do
      let(:rider) { double(x: 0, y: 0, speed: 1000000) }

      let(:restaurant) { double(x: 1, y: 1, cooking_time: 35) }

      it 'equals cooking time + restaurant-customer time' do
        expect(delivery_time.round(2)).to eq(restaurant.cooking_time)
      end
    end

    context 'when rider time to get to the restaurant is above cooking time' do
      let(:restaurant) { double(x: 1, y: 1, cooking_time: 5) }

      it 'equals rider-restaurant time + restaurant-customer time' do
        is_expected.to be > restaurant.cooking_time
      end
    end
  end

  describe '#distance_for' do
    it 'equals the euclidian distance between rider-restaurant plus restaurant-customer' do
      distance_test_table.each do |distance_test|
        order = Order.new(
          restaurant: distance_test[:restaurant], customer: distance_test[:customer]
        )
        expect(
          order.distance_for(distance_test[:rider]).round(2)
        ).to eq(distance_test[:result])
      end
    end

    let(:distance_test_table) do
      [
        {
          rider:      double(x: 0, y: 0),
          restaurant: double(x: 1, y: 1),
          customer:   double(x: 2, y: 2),
          result:     2.83
        },
        {
          rider:      double(x: 4, y: 3),
          restaurant: double(x: 5, y: 8),
          customer:   double(x: 2, y: 9),
          result:     8.26
        },
        {
          rider:      double(x: 1, y: 0),
          restaurant: double(x: 4, y: 3),
          customer:   double(x: 9, y: 3),
          result:     9.24
        }
      ]
    end
  end

  describe '#mark_as_dispatched_by!' do
    let(:rider) { double() }

    subject! { order.mark_as_dispatched_by!(rider) }

    it 'assigns the rider as dispatcher' do
      expect(order.dispatcher).to eq(rider)
    end
  end
end
