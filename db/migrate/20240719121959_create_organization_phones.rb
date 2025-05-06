# frozen_string_literal: true

class CreateOrganizationPhones < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_phones, id: false do |t|
      t.references :phone, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.index %i[organization_id phone_id]
    end
  end
end
