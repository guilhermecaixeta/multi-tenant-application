# frozen_string_literal: true
# typed: true

# migration class
class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.integer :total_items, null: false, default: 0
      t.date :validity, null: false
      t.string :brand, limit: 255

      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
