# frozen_string_literal: true
# typed: true

# rubocop:disable Rails/InverseOf
# rubocop:disable Rails/HasManyOrHasOneDependent

# Product class
class Product < ApplicationRecord
  include CatalogableConcern
  include ProductCalculatorConcern

  has_one :measure,
          as: :measurable,
          class_name: Measure.name.to_s,
          dependent: :destroy

  has_one :suggested_price,
          -> { where(category: Price.categories[:suggested]).order(created_at: :DESC) },
          as: :priceable,
          class_name: Price.name.to_s,
          dependent: :destroy

  has_one :cost_price,
          -> { where(category: Price.categories[:unit_cost]).order(created_at: :DESC) },
          as: :priceable,
          class_name: Price.name.to_s,
          dependent: :destroy

  has_many :product_sale_items

  has_many :sales,
           through: :product_sale_items

  has_many :prices,
           as: :priceable,
           class_name: Price.name.to_s,
           dependent: :destroy,
           autosave: true

  accepts_nested_attributes_for :measure,
                                :cost_price,
                                :suggested_price,
                                allow_destroy: true

  scope :calculate_last_cost_price_cents,
        lambda { |product_id|
          calculate_cost_price
            .where(id: product_id)
            .first!
            .price_cents
        }

  scope :load_all,
        lambda {
          eager_load(:measure, :catalog)
            .preload(:cost_price, :suggested_price, catalog: :price)
            .select('products.id',
                    'products.total_items',
                    'measures.quantity AS measures_quantity',
                    'measures.base_unit AS measures_base_unit')
            .order(' catalogs.name asc')
        }

  scope :calculate_cost_price,
        lambda {
          entry_prices_sql = ::Entry.prices
                                    .where('entries.stock_id = stocks.id')
                                    .limit(1)
                                    .to_sql
          select_sql = <<~QUERY
            CAST(
              SUM((measures_items.quantity / products.total_items) * (#{entry_prices_sql}) / measures_stocks.quantity) AS integer)
                AS price_cents
          QUERY

          joins(:measure, catalog: { items: [:measure, { stock: :measure }] })
            .select(Arel.sql(select_sql))
            .group(:id)
        }
end
# rubocop:enable Rails/InverseOf
# rubocop:enable Rails/HasManyOrHasOneDependent
