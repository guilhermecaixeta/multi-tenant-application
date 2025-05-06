# frozen_string_literal: true
# typed: true

# migration class
class CreateSales < ActiveRecord::Migration[7.1]
  def change
    create_table :sales do |t|
      t.references :saleable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
