require "json"
require "pry"
require_relative './food_item'
require_relative './exceptions/bakery'
require_relative './processors/package'

class Bakery
  SEED_DATA_FILE = "./lib/data/products.json".freeze

  attr_accessor :inventory, :items

  def initialize
    @items = populated_food_items
  end

  def process_packaging(quantity, code)
    raise Exceptions::Bakery.new(:invalid_product_code) unless code_valid?(code)

    processor = Processors::Package.new(
      bakery: self,
      quantity: quantity,
      code: code
    )
    processor.process!
  end

  def item_by_code(code)
    @items.select { |item| item.code == code }&.first
  end

  private

  def code_valid?(code)
    @items.map(&:code).include?(code)
  end

  def populated_food_items
    JSON.parse(File.open(Bakery::SEED_DATA_FILE).read).map do |item|
      item = FoodItem.new(name: item["name"], code: item["code"], packs: item["packs"])
      item.define_packs
      item
    end
  end
end
