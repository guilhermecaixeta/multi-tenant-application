# frozen_string_literal: true
# typed: true

# migration class
class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.boolean :show_on_site, default: false
      t.integer :total_items

      t.timestamps
    end
  end
end
