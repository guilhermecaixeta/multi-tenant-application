# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false, limit: 255
      t.string :domain, null: false, limit: 255
      t.string :email, null: false, limit: 255
      t.string :code, null: false, limit: 64
      t.string :government_number, limit: 32

      t.timestamps

      t.index %i[name code domain]
    end
  end
end
