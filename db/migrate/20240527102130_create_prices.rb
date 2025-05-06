# frozen_string_literal: true
# typed: true

# migration class
class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.monetize :price, null: false
      t.string :category, null: false, limit: 255
      t.references :priceable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
