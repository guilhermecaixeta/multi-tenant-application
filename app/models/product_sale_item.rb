# frozen_string_literal: true
# typed: true

# Class ProductSaleItem
class ProductSaleItem < ApplicationRecord
  extend T::Sig

  enum :category, %w[sale waste reimburse].index_by(&:to_sym)

  after_create ProductSaleItemCallbacks.new,
               prepend: true
  after_update ProductSaleItemCallbacks.new,
               prepend: true
  before_destroy ProductSaleItemCallbacks.new,
                 prepend: true

  belongs_to :product
  belongs_to :product_sale

  has_one :price,
          -> { where(category: :price).order(created_at: :desc) },
          as: :priceable,
          dependent: :destroy

  has_many :prices,
           as: :priceable,
           dependent: :destroy

  validates :category,
            presence: true

  validates :profit_rate,
            presence: true,
            numericality: { greater_than: 0.00 },
            unless: proc { |r| r.use_default_price }

  validates :total_items,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  validates_associated :price,
                       unless: proc { |r| r.use_default_price }

  accepts_nested_attributes_for :price,
                                allow_destroy: true

  monetize :price_total_cents

  def price_total_cents
    return 0 if total_items.nil? || T.must(total_items).negative?

    T.must(price).price_cents * T.must(total_items)
  end
end
