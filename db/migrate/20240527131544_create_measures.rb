# frozen_string_literal: true
# typed: true

# migration class
class CreateMeasures < ActiveRecord::Migration[7.1]
  def change
    create_table :measures do |t|
      t.decimal :quantity, precision: 18, scale: 2, null: false
      t.string :base_unit, null: false, default: 'g'
      t.string :kind, limit: 32, default: 'total'

      t.references :unit, null: false, foreign_key: true
      t.references :measurable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
