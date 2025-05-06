# frozen_string_literal: true
# typed: true

# migration class
class CreateProfileAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_addresses, id: false do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.index %i[profile_id address_id]
    end
  end
end
