# frozen_string_literal: true

class CreateJoinTableOrganizationRoleOrganizationPermission < ActiveRecord::Migration[7.1]
  def change
    create_join_table :organization_roles, :organization_permissions do |t|
      t.index %i[organization_role_id organization_permission_id]
    end
  end
end
