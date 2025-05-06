# frozen_string_literal: true

class CreateOrganizationUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_user_roles do |t|
      t.references :role, null: false, foreign_key: true
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end
