class OrdersController < ApplicationController
  def show
    @order = Order.last || Order.create!
  end

  def create
  end
end
