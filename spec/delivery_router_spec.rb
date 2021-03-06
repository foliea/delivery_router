=begin
  This file is a simple Ruby RSpec test suite describing a DeliveryRouter class.
  Your goals are to:
  1) make those tests pass,
  2) add tests for the edge cases.
  If you need help to setup the project, see: https://gist.github.com/gaeldelalleau/f486f9e5fdcece8eb36e70f23c806184
  Feel free to ask us any question!

  Happy hacking :)
  --
  Goal: delight your customers by sending riders to pick and deliver their orders
  in less than 60 minutes (faster if you can).
  Hypothesis:
    - (x, y) coordinates are used to locate restaurants, customers and riders on a grid
    - the distance between x=0 and x=1 is 1000 meters (1 km)
    - the distance between two arbitrary (x,y) locations is the euclidian distance (straight line)
    - times are expressed in minutes
    - speeds are expressed in kilometers per hour (km/h)
  Note: some other hypothesis you can make to simplify the problem:
    - all customer orders are received at the same time (t=0)
    - all restaurants start cooking at the same time (t=0)
    - all riders start moving at the same time (t=0)
    - each restaurant can cook an infinite number of meals in parallel
    - each rider can carry an infinite amount of meals at the same time
    - riders are ninjas! They fly over trafic jams and buildings, they never need to take
      a break and they know how to solve a NP-complete problem in polynomial time ;)
=end

require 'delivery_router'

describe DeliveryRouter do
  describe "#route" do

    before(:all) do
      @customers = [
          Customer.new(:id => 1, :x => 1, :y => 1),
          Customer.new(:id => 2, :x => 5, :y => 1),
          Customer.new(:id => 3, :x => 0, :y => 5),
          Customer.new(:id => 4, :x => 0, :y => 5),
          Customer.new(:id => 5, :x => 0, :y => 7),
          Customer.new(:id => 6, :x => 0, :y => 7),
          Customer.new(:id => 7, :x => 5, :y => 13),
          Customer.new(:id => 8, :x => 6, :y => 13),
        ]
      @restaurants = [
        Restaurant.new(:id => 3, :cooking_time => 15, :x => 0, :y => 0),
        Restaurant.new(:id => 4, :cooking_time => 35, :x => 5, :y => 5),
        Restaurant.new(:id => 5, :cooking_time => 5,  :x => 0, :y => 4),
        Restaurant.new(:id => 6, :cooking_time => 5,  :x => 0, :y => 8),
        Restaurant.new(:id => 7, :cooking_time => 10, :x => 6, :y => 14),
      ]
      @riders = [
        Rider.new(:id => 1, :speed => 10, :x => 2, :y => 0),
        Rider.new(:id => 2, :speed => 10, :x => 1, :y => 0),
        Rider.new(:id => 3, :speed => 5,  :x => 1, :y => 4),
        Rider.new(:id => 4, :speed => 5,  :x => 1, :y => 4),
        Rider.new(:id => 5, :speed => 10, :x => 1, :y => 12),
        Rider.new(:id => 6, :speed => 10, :x => 0, :y => 11),
        Rider.new(:id => 7, :speed => 10, :x => 4, :y => 14),
        Rider.new(:id => 8, :speed => 10, :x => 4, :y => 14),
      ]
      @delivery_router = DeliveryRouter.new(@restaurants, @customers, @riders)
    end

    context "given customer 1 orders from restaurant 3" do
      before(:all) do
        @delivery_router.add_order(:customer => 1, :restaurant => 3)
      end

      context "given customer 2 does not order anything" do
        before(:all) do
          @delivery_router.clear_orders(:customer => 2)
        end

        it "does not assign a route to rider 1" do
          route = @delivery_router.route(:rider => 1)
          expect(route).to be_empty
        end

        it "sends rider 2 to customer 1 through restaurant 3" do
          route = @delivery_router.route(:rider => 2)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(3)
          expect(route[1].id).to eql(1)
        end

        it "delights customer 1" do
          expect(@delivery_router.delivery_time(:customer => 1)).to be < 60
        end
      end

      context "given customer 2 orders from restaurant 4" do
        before(:all) do
          @delivery_router.add_order(:customer => 2, :restaurant => 4)
        end

        it "sends rider 1 to customer 2 through restaurant 4" do
          route = @delivery_router.route(:rider => 1)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(4)
          expect(route[1].id).to eql(2)
        end

        it "sends rider 2 to customer 1 through restaurant 3" do
          route = @delivery_router.route(:rider => 2)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(3)
          expect(route[1].id).to eql(1)
        end

        it "delights customer 1" do
          expect(@delivery_router.delivery_time(:customer => 1)).to be < 60
        end

        it "delights customer 2" do
          expect(@delivery_router.delivery_time(:customer => 2)).to be < 60
        end
      end
    end

    context "given customer 3 orders from restaurant 5" do
      before(:all) do
        @delivery_router.add_order(:customer => 3, :restaurant => 5)
      end

      context "given customer 4 orders from restaurant 5" do
        before(:all) do
          @delivery_router.add_order(:customer => 4, :restaurant => 5)
        end

        it "sends rider 3 to customer 3 through restaurant 5" do
          route = @delivery_router.route(:rider => 3)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(5)
          expect(route[1].id).to eql(3)
        end

        it "sends rider 4 to customer 4 through restaurant 5" do
          route = @delivery_router.route(:rider => 4)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(5)
          expect(route[1].id).to eql(4)
        end

        it "delights customer 3" do
          expect(@delivery_router.delivery_time(:customer => 3)).to be < 60
        end

        it "delights customer 4" do
          expect(@delivery_router.delivery_time(:customer => 4)).to be < 60
        end
      end
    end

    context "given customer 5 orders from restaurant 6" do
      before(:all) do
        @delivery_router.add_order(:customer => 5, :restaurant => 6)
      end

      context "given customer 6 orders from restaurant 6" do
        before(:all) do
          @delivery_router.add_order(:customer => 6, :restaurant => 6)
        end

        it "sends rider 5 to customer 6 through restaurant 6" do
          route = @delivery_router.route(:rider => 5)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(6)
          expect(route[1].id).to eql(6)
        end

        it "sends rider 6 to customer 5 through restaurant 6" do
          route = @delivery_router.route(:rider => 6)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(6)
          expect(route[1].id).to eql(5)
        end

        it "delights customer 5" do
          expect(@delivery_router.delivery_time(:customer => 5)).to be < 60
        end

        it "delights customer 6" do
          expect(@delivery_router.delivery_time(:customer => 6)).to be < 60
        end
      end
    end

    context "given customer 7 orders from restaurant 7" do
      before(:all) do
        @delivery_router.add_order(:customer => 7, :restaurant => 7)
      end

      it "sends rider 7 to customer 7 through restaurant 7" do
        route = @delivery_router.route(:rider => 7)
        expect(route.length).to eql(2)
        expect(route[0].id).to eql(7)
        expect(route[1].id).to eql(7)
      end

      it "delights customer 7" do
        expect(@delivery_router.delivery_time(:customer => 7)).to be < 60
      end

      context "given customer 8 orders from restaurant 7" do
        before(:all) do
          @delivery_router.add_order(:customer => 8, :restaurant => 7)
        end

        it "sends rider 8 to customer 8 through restaurant 7" do
          route = @delivery_router.route(:rider => 8)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(7)
          expect(route[1].id).to eql(8)
        end

        it "delights customer 8" do
          expect(@delivery_router.delivery_time(:customer => 8)).to be < 60
        end
      end
    end
  end
end
