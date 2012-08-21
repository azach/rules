class OrdersController < ApplicationController
  include Rules::FormsHelper

  helper_method :rules_for

  def show
    @order = Order.last || Order.create!
  end

  def create
  end
end
