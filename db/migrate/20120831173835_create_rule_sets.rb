class CreateRuleSets < ActiveRecord::Migration
  def change
    create_table :rules_rule_sets do |t|
      t.belongs_to :source, polymorphic: true
      t.string :evaluation_logic

      t.timestamps
    end
  end
end
