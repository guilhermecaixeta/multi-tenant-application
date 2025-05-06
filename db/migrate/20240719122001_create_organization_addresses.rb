# frozen_string_literal: true

class CreateOrganizationAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_addresses, id: false do |t|
      t.references :address, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.index %i[organization_id address_id]
    end
  end
end
