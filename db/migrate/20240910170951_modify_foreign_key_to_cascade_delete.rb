# frozen_string_literal: true

class ModifyForeignKeyToCascadeDelete < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :profiles, :users
    add_foreign_key :profiles, :users, on_delete: :cascade

    remove_foreign_key :organization_users, :users
    add_foreign_key :organization_users, :users, on_delete: :cascade

    remove_foreign_key :organization_users, :organizations
    add_foreign_key :organization_users, :organizations, on_delete: :cascade
  end
end
