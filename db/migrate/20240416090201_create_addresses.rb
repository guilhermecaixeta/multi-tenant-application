# frozen_string_literal: true
# typed: true

# migration class
class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :compliment
      t.string :city
      t.string :state
      t.string :postal_code

      t.timestamps
    end
  end
end
