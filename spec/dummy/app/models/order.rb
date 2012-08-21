class Order < ActiveRecord::Base
  attr_accessible :customer, :placed, :price, :quantity, :shipped

  include Rules::HasRules
end
