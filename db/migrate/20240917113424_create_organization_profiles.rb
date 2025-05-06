# frozen_string_literal: true

class CreateOrganizationProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_profiles do |t|
      t.string :slogan, null: false, limit: 255

      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
