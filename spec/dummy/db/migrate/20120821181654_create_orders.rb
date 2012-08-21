class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.decimal :price
      t.string :customer
      t.date :placed
      t.date :shipped

      t.timestamps
    end
  end
end
