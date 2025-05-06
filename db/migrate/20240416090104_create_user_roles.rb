# frozen_string_literal: true
# typed: true

# migration class
class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.index %i[user_id role_id]
    end
  end
end
