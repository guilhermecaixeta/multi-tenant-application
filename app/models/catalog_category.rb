# frozen_string_literal: true
# typed: true

# Catalog Category Model
class CatalogCategory < ApplicationRecord
  has_one_attached :default_picture

  has_rich_text :description

  has_and_belongs_to_many :catalogs

  scope :load_all_for_site,
        lambda {
          joins(:default_picture_attachment,
                catalogs: %i[price])
            .left_joins(:rich_text_description,
                        catalogs: %i[picture_attachment
                                     rich_text_description])
            .eager_load(:rich_text_description,
                        default_picture_attachment: :blob,
                        catalogs: [:price,
                                   :rich_text_description,
                                   { picture_attachment: :blob }])
            .where(catalogs: { show: true })
            .references(:catalogs)
        }
end
