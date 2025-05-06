# frozen_string_literal: true
# typed: true

# migration
class CreateProductSaleItems < ActiveRecord::Migration[7.1]
  def change
    create_table :product_sale_items do |t|
      t.belongs_to :product
      t.belongs_to :product_sale

      t.integer :total_items
      t.boolean :use_default_price, null: false, default: false

      t.decimal :profit_rate, precision: 18, scale: 2, null: false
      t.string :category, null: false, default: 'sale', limit: 32

      t.timestamps
      t.index %i[product_id product_sale_id]
    end
  end
end
