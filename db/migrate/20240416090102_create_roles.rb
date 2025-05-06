# frozen_string_literal: true
# typed: true

# migration class
class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name, limit: 255, null: false
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
