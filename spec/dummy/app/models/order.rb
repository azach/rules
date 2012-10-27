class Order < ActiveRecord::Base
  attr_accessible :customer, :placed, :price, :quantity, :shipped

  include Rules::HasRules

  has_rule_attributes({
    customer_email: {
      name: 'customer email address'
    },
    order_price: {
      name: 'order price'
    }
  })

  def check_if_valid
    evaluate \
      customer: customer,
      price: price
  end
end
