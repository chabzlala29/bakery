module Exceptions
  class Bakery < StandardError
    ERRORS = {
      default: "We have a problem with our Bakery, please check your input",
      invalid_product_code: "Product code not found.",
      invalid_number_of_items: "You inputted an invalid number of product, we only accept minimal number of items to minimize shipping cost, please adjust accordingly."
    }

    def initialize(code = nil, extra_msg = nil)
      super(Exceptions::Bakery::ERRORS[code || :default] + extra_msg)
    rescue
      super(Exceptions::Bakery::ERRORS[:default])
    end
  end
end
