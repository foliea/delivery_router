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

  xdescribe '#delivery_time_for' do
    subject { order.delivery_time_for(rider) }

    context 'when rider time to get to the restaurant is below cooking time' do
      it 'is equal to rider-restaurant time plus restaurant-customer time' do

      end
    end

    context 'when rider time to get to the restaurant is above cooking time' do
      it 'is equal to restaurant cooking time plus restaurant-customer time' do

      end
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
