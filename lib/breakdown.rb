class Breakdown
  attr_reader :quantity, :price

  def initialize(quantity:, price:)
    @quantity, @price = quantity, price
  end

  def to_h
    {
      number_of_boxes: quantity,
      price_per_box: price
    }
  end

  def total_cost
    quantity * price
  end
end
