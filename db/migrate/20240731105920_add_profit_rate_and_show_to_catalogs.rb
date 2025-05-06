# frozen_string_literal: true

class AddProfitRateAndShowToCatalogs < ActiveRecord::Migration[7.1]
  def change
    add_column :catalogs, :profit_rate, :decimal, precision: 18, scale: 2, default: 0.0, null: false
    add_column :catalogs, :show, :boolean, default: false, null: false
  end
end
