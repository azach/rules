class CreatePenNames < ActiveRecord::Migration
  def change
    create_table :pen_names do |t|
      t.belongs_to :author
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
