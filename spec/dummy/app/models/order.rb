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
end
