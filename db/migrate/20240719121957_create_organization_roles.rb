# frozen_string_literal: true

class CreateOrganizationRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_roles, id: false do |t|
      t.references :role, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps

      t.index %i[organization_id role_id]
    end
  end
end
