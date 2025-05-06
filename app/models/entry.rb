# frozen_string_literal: true
# typed: true

# Model class
class Entry < ApplicationRecord
  include RebalanceEntriesConcern

  before_validation EntryCallbacks.new,
                    on: %i[create update]

  after_create EntryCallbacks.new
  after_update EntryCallbacks.new
  after_destroy EntryCallbacks.new

  belongs_to :stock

  has_one :price, # rubocop:disable Rails/InverseOf
          -> { where(category: Price.categories[:price]) },
          as: :priceable,
          class_name: 'Price',
          dependent: :destroy,
          autosave: true

  has_one :quantity_available,
          as: :measurable,
          class_name: 'Measure',
          dependent: :destroy,
          autosave: true

  accepts_nested_attributes_for :price,
                                allow_destroy: true

  scope :recent,
        lambda {
          order(:validity)
        }

  scope :prices, lambda {
    joins(:quantity_available)
      .joins(:price)
      .where('measures.quantity > 0')
      .order(:validity)
      .select('prices.price_cents')
  }

  monetize :total_price_cents

  validates_associated :price

  validates :price,
            presence: true

  validates :validity,
            presence: true,
            comparison: { greater_than: Time.zone.now }

  validates :total_items,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  def total_price_cents
    return 0 if price.nil? || total_items.nil?

    total_items * price.price_cents
  end

  def quantity_total
    return 0 if stock_id.nil? || T.must(stock).measure.nil?

    T.must(T.must(stock).measure).quantity * total_items
  end
end
