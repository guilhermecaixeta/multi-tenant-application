# frozen_string_literal: true
# typed: true

# migration
class CreateOrganizationUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_users, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.boolean :principal, default: true

      t.timestamps
      t.index %i[organization_id user_id]
    end
  end
end
