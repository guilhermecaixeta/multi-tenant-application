# frozen_string_literal: true

class CreateCatalogCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :catalog_categories do |t|
      t.string :title, limit: 64, null: false

      t.timestamps
    end
  end
end
