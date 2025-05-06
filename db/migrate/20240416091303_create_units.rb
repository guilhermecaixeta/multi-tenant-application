# frozen_string_literal: true
# typed: true

# migration class
class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :long_name, limit: 255, null: false
      t.string :short_name, limit: 3, null: false
      t.integer :quantity, null: false
      t.integer :unit_type, null: false, default: 0
      t.boolean :is_default, default: false

      t.timestamps
      t.index %i[unit_type is_default], unique: true
    end
  end
end
