# frozen_string_literal: true
# typed: true

# migration class
class CreateProductSales < ActiveRecord::Migration[7.1]
  def change
    create_table :product_sales, &:timestamps
  end
end
