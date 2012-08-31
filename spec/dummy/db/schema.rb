# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120831173835) do

  create_table "orders", :force => true do |t|
    t.integer  "quantity"
    t.decimal  "price"
    t.string   "customer"
    t.date     "placed"
    t.date     "shipped"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rules_rule_sets", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.string   "evaluation_logic"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "rules_rules", :force => true do |t|
    t.integer  "rule_set_id"
    t.string   "evaluator"
    t.text     "parameters"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
