# frozen_string_literal: true

class CreateOrganizationPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_permissions, id: false do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps

      t.index %i[organization_id permission_id]
    end
  end
end
