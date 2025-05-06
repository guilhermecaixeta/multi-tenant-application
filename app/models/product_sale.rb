# rubocop:disable Rails/InverseOf
# frozen_string_literal: true
# typed: true

# Class ProductSale
class ProductSale < ApplicationRecord
  include ProductSaleExpenseConcern
  include SaleableConcern

  after_create ProductSaleCallbacks.new
  after_update ProductSaleCallbacks.new

  has_many :product_sale_items,
           dependent: :destroy,
           autosave: true

  has_many :products,
           through: :product_sale_items,
           dependent: :destroy

  has_one :expenses,
          -> { where(category: Price.categories[:expenses]) },
          as: :priceable,
          class_name: 'Price',
          dependent: :destroy

  accepts_nested_attributes_for :sale,
                                :product_sale_items,
                                allow_destroy: true

  def self.build(attributes = nil, &)
    product_sale = super
    if attributes.is_a?(Array)
      product_sale.each(&:define_default_price)
    else
      product_sale.define_default_price
    end
    product_sale
  end

  def assign_attributes(new_attributes)
    super

    define_default_price
  end

  def product_names
    product_sale_items
      .map { |sale_item| T.must(T.must(sale_item.product).catalog).name }
      .uniq { |name| name }
      .join ', '
  end

  def revenue_cents
    return 0 if product_sale_items.empty?

    product_sale_items
      .filter { |sale_item| sale_item.category == ProductSaleItem.categories[:sale] }
      .sum(&:price_total_cents)
  end

  def loss_cents
    return 0 if product_sale_items.empty?

    product_sale_items
      .filter { |sale_item| !sale_item.sale? }
      .sum do |sale_item|
      Product.joins(:cost_price)
             .where(id: sale_item.product_id)
             .sum('prices.price_cents') * T.must(sale_item.total_items)
    end
  end

  def total_expenses_cents # rubocop:disable Metrics/MethodLength
    return 0 if sale.nil?

    case [expenses.present?, T.must(sale).expenses.present?]
    when [true, true]
      T.must(expenses).price_cents + T.must(T.must(sale).expenses).price_cents
    when [false, true]
      T.must(T.must(sale).expenses).price_cents
    when [true, false]
      T.must(expenses).price_cents
    else
      0
    end
  end

  sig { void }
  def define_default_price
    product_sale_items.each do |sale_item|
      next unless sale_item.use_default_price

      sale_item.profit_rate = 0

      price_cents = select_price_when_using_default_value(sale_item.product_id)

      sale_item.price = Price.build(price_cents:,
                                    category: :price)
    end
  end

  private

  def select_price_when_using_default_value(product_id)
    Price.where(priceable_type: Catalog.name)
         .where(priceable_id: product_id)
         .where(category: :price)
         .where('price_cents > 0')
         .pick(:price_cents) ||
      Price.where(priceable_type: Product.name)
           .where(priceable_id: product_id)
           .where(category: :suggested)
           .pick(:price_cents)
  end
end
# rubocop:enable Rails/InverseOf
