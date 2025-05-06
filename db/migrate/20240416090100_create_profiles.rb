# frozen_string_literal: true
# typed: true

# migration class
class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false, limit: 255
      t.string :last_name, null: false, limit: 255
      t.string :middle_name, limit: 255

      t.date :birthdate, null: false

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
