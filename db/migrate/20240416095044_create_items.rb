# frozen_string_literal: true
# typed: true

# migration class
class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
