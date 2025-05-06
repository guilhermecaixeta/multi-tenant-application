# frozen_string_literal: true
# typed: true

# migration class
class CreatePhones < ActiveRecord::Migration[7.1]
  def change
    create_table :phones do |t|
      t.string :country_code
      t.string :phone_number

      t.timestamps
    end
  end
end
