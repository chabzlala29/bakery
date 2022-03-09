require_relative "./spec_helper"
require_relative "../../lib/bakery"

RSpec.describe "Bakery" do
  let(:bakery) { Bakery.new }
  let(:processor) { Processors::Package.new(bakery: bakery, quantity: quantity, code: code) }
  let(:quantity) { 10 }
  let(:code) { "VS5" }


  it { expect(bakery.items.count).to eq(3) }
  it { expect(bakery.send(:code_valid?, "VS5")) }

  it { expect(bakery.item_by_code("VS5")).to be_an_instance_of(FoodItem) }
  it { expect(bakery.item_by_code("VS5").packs.collect(&:quantity)).to eq([3, 5]) }

  it "should calculate packaging correctly" do
    expect(processor.process!).to eq({
      sorted_packages: [
        {
          number_of_boxes: 2,
          price_per_box: 8.99
        }
      ],
      total_cost: 17.98
    })
  end

  describe 'MB11 with 14 items' do
    let(:code) { "MB11" }
    let(:quantity) { 14 }

    it "should calculate packaging correctly" do
      expect(processor.process!).to eq({
        sorted_packages: [
          {
            number_of_boxes: 1,
            price_per_box: 24.95
          },
          {
            number_of_boxes: 3,
            price_per_box: 9.95
          }
        ],
        total_cost: 54.8
      })
    end
  end

  describe 'CF with 13 items' do
    let(:code) { "CF" }
    let(:quantity) { 13 }

    it "should calculate packaging correctly" do
      expect(processor.process!).to eq({
        sorted_packages: [
          {
            number_of_boxes: 2,
            price_per_box: 9.95
          },
          {
            number_of_boxes: 1,
            price_per_box: 5.95
          }
        ],
        total_cost: 25.85
      })
    end
  end


  context "Additional scenarios" do
    describe 'CF with 122 items' do
      let(:code) { "CF" }
      let(:quantity) { 122 }

      it "should calculate packaging correctly" do
        expect(processor.process!).to eq({
          sorted_packages: [
            {
              number_of_boxes: 13,
              price_per_box: 16.99
            },
            { number_of_boxes: 1,
              price_per_box: 9.95
            }
          ],
          total_cost: 230.82
        })
      end
    end

    describe 'VS5 with unpackagable 120 items' do
      let(:code) { "VS5" }
      let(:quantity) { 121 }

      it "should raise an invalid number of items error" do
        expect { processor.process! }.to raise_error(an_instance_of(Exceptions::Bakery).and having_attributes(message: "You inputted an invalid number of product, we only accept minimal number of items to minimize shipping cost, please adjust accordingly. Number of items should be divisible by 3 or 5"))
      end
    end

    describe 'Invalid quantity' do
      let(:code) { "VS5" }
      let(:quantity) { "notanumber" }

      it "should raise an invalid number of items error" do
        expect { processor.process! }.to raise_error(an_instance_of(Exceptions::Bakery).and having_attributes(message: "Invalid quantity."))
      end
    end
  end
end
