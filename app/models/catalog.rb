# rubocop:disable Rails/InverseOf
# frozen_string_literal: true
# typed: true

# Model class
class Catalog < ApplicationRecord
  before_validation CatalogCallbacks.new

  delegated_type :catalogable,
                 types: %w[Product Service],
                 dependent: :destroy

  has_rich_text :description

  has_one_attached :picture

  has_one :price,
          -> { where(category: Price.categories[:price]).order(created_at: :DESC) },
          as: :priceable,
          class_name: Price.name,
          dependent: :destroy

  has_and_belongs_to_many :catalog_categories

  has_many :prices,
           -> { where(category: Price.categories[:price]) },
           class_name: Price.name,
           foreign_key: "priceable_id",
           dependent: :destroy,
           autosave: true

  has_many :items,
           class_name: Item.name,
           dependent: :destroy

  validates :catalogable,
            presence: true

  validates :name,
            presence: true,
            length: { minimum: 2,
                      maximum: 255 }

  validates :catalog_category_ids,
            presence: true,
            length: { minimum: 1 }

  validates :description,
            length: { minimum: 5,
                      maximum: 800 },
            if: proc { |r| r.description.present? }

  validates :items,
            length: { minimum: 1 }

  validates :picture,
            content_type: Rails.configuration.x.attachment.allowed_formats_for_images,
            size: { less_than: Rails.configuration.x.attachment.max_image_size },
            if: -> { !picture&.attached? }

  validates_associated :catalogable,
                       :price,
                       :items

  accepts_nested_attributes_for :price,
                                :items,
                                :catalogable,
                                allow_destroy: true
end
# rubocop:enable Rails/InverseOf
