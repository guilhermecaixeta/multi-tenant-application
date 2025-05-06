# frozen_string_literal: true
# typed: true

# migration class
class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :name, null: false, limit: 255

      t.integer :minimum_stock_level, default: 0
      t.integer :maximum_stock_level, default: 0
      t.timestamps

      t.index %i[name]
    end
  end
end
