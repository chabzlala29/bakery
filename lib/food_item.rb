require 'active_model'
require_relative './pack'

class FoodItem
  include ActiveModel::Model

  attr_accessor :name, :code, :packs

  validates :name, presence: true
  validates :code, presence: true
  validates :packs, presence: true

  def define_packs
    @packs = packs.map do |pack|
      Pack.new(quantity: pack["quantity"], price: pack["price"])
    end
  end
end
