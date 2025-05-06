# frozen_string_literal: true
# typed: true

# migration class
class CreateRolePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :role_permissions, id: false do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.index %i[role_id permission_id]
    end
  end
end
