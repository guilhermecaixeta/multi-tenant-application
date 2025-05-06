# frozen_string_literal: true

class CreateJoinTableCatalogCatalogCategory < ActiveRecord::Migration[7.1]
  def change
    create_join_table :catalogs, :catalog_categories do |t|
      t.index %i[catalog_id catalog_category_id]
    end
  end
end
