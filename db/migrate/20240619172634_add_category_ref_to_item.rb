# frozen_string_literal: true
# typed: true

# migration class
class AddCategoryRefToItem < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :category, null: false, foreign_key: true
  end
end
