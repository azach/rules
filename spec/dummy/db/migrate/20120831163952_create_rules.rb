class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules_rules do |t|
      t.belongs_to :rule_set
      t.string :evaluator
      t.text :parameters

      t.timestamps
    end
  end
end
