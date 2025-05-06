# frozen_string_literal: true

class CreateAccessControls < ActiveRecord::Migration[7.1]
  def change
    create_table :access_controls do |t|
      t.boolean :active
      t.datetime :active_from
      t.datetime :active_until
      t.references :controlable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
