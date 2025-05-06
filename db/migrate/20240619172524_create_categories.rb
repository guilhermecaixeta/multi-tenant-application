# frozen_string_literal: true
# typed: true

# migration class
class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 128

      t.timestamps
    end
  end
end
