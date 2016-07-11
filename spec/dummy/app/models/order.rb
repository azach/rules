class Order < ActiveRecord::Base
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
