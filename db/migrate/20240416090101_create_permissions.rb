# frozen_string_literal: true
# typed: true

# migration class
class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.string :title, limit: 255, null: false
      t.string :scope, limit: 400, null: false

      t.timestamps
    end
  end
end
