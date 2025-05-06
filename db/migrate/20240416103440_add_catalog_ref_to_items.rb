# frozen_string_literal: true
# typed: true

# migration class
class AddCatalogRefToItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :catalog, null: false, foreign_key: true
  end
end
