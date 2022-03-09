require 'active_model'

class Pack
  include ActiveModel::Model

  attr_accessor :quantity, :price

  validates :quantity, presence: true, numericality: true
  validates :price, presence: true, numericality: true
end
