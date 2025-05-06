# frozen_string_literal: true
# typed: true

# migration class
class CreateCatalogs < ActiveRecord::Migration[7.1]
  def change
    create_table :catalogs do |t|
      t.string :name, null: false, limit: 255
      t.references :catalogable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
