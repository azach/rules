class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.belongs_to :author
      t.string :title
      t.integer :year

      t.timestamps
    end
  end
end
