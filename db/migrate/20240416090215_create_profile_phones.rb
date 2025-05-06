# frozen_string_literal: true
# typed: true

# migration class
class CreateProfilePhones < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_phones, id: false do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :phone, null: false, foreign_key: true

      t.index %i[profile_id phone_id]
    end
  end
end
