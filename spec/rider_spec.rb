require 'rider'

describe Rider do
  let(:rider) { Rider.new(id: 1, speed: 10, x: 12, y: 13) }

  let(:order) do
    double(mark_as_dispatched_by!: true, restaurant: double(), customer: double())
  end

  describe '#dispatch!' do
    subject(:dispatch!) { rider.dispatch!(order) }

    before { dispatch! }

    it 'dispatches the order' do
      expect(rider).to be_dispatching_order(order)
    end

    it 'marks the order as dispatching' do
      expect(order).to have_received(:mark_as_dispatched_by!).with(rider)
    end
  end

  describe '#dispatched?' do
    subject { rider.dispatched? }

    context "when rider doesn't have any order" do
      it { is_expected.to be_falsey }
    end

    context 'when rider has an order' do
      before { rider.dispatch!(order) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#dispatching_order?' do
    subject { rider.dispatching_order?(order) }

    context 'when rider is not dispatching any order' do
      it { is_expected.to be_falsey }
    end

    context 'when rider is dispatching the order' do
      before { rider.dispatch!(order) }

      it { is_expected.to be_truthy }
    end

    context 'when rider is dispatching another order' do
      let(:another_order) { double(mark_as_dispatched_by!: true) }

      before { rider.dispatch!(another_order) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#cancel_dispatching!' do
    subject { rider.cancel_dispatching! }

    context 'when rider has an order' do
      before do
        rider.dispatch!(order)

        rider.cancel_dispatching!
      end

      it 'cancels the dispatching' do
        expect(rider).to_not be_dispatched
      end
    end
  end

  describe '#route' do
    subject { rider.route }

    context 'when rider is not dispatched' do
      it { is_expected.to eq([])}
    end

    context 'when rider is dispatched' do
      before { rider.dispatch!(order) }

      it { is_expected.to eq([order.restaurant, order.customer])}
    end
  end
end
