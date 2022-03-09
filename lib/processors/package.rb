require_relative "../breakdown"
require_relative "../exceptions/bakery"

module Processors
  class Package
    DEFAULT_INT_ROUND = 2.freeze

    attr_reader :bakery, :quantity, :code, :breakdown, :packs, :item, :max_pack_qty, :remaining_qty

    def initialize(bakery:, quantity:, code:)
      @bakery = bakery
      @quantity = quantity
      @code = code
      @item = bakery.item_by_code(code)
      @packs = item.packs
      @max_pack_qty = packs.collect(&:quantity).max
      @remaining_qty = quantity
      @breakdown = []
    end

    def process!
      packs.sort_by{ |pack| -pack.quantity }.each do |pack|
        pack_quantity = pack.quantity
        remainder = remaining_qty % pack_quantity

        break if remaining_qty.zero?
        next unless divisible_by_any_pack?(remainder)

        breakdown << Breakdown.new(
          quantity: remaining_qty / pack_quantity,
          price: pack.price
        )

        @remaining_qty = remainder
      end

      sorted_packages = breakdown.map(&:to_h)

      check_item_validity!(sorted_packages)

      {
        total_cost: breakdown.map(&:total_cost).sum.round(Processors::Package::DEFAULT_INT_ROUND),
        sorted_packages: sorted_packages
      }
    end

    private

    def check_item_validity!(sorted_packages)
      raise Exceptions::Bakery.new(
        :invalid_number_of_items,
        " Number of items should be divisible by #{ packs.map(&:quantity).to_sentence(last_word_connector: ", or ", two_words_connector: " or ") }"
      ) if sorted_packages.empty?
    end

    def divisible_by_any_pack?(remainder)
      packs.map { |pack| remainder % pack.quantity }.include?(0)
    end
  end
end
