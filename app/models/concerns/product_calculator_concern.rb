# frozen_string_literal: true
# typed: true

# rubocop:disable Metrics/MethodLength

# Concern
module ProductCalculatorConcern
  extend T::Sig
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    sig { void }
    def recalculate_prices
      cost_price_cents = ::Product.calculate_last_cost_price_cents id
      suggested_price_cents = T.must(cost_price_cents).percent_from(catalog.profit_rate) + T.must(cost_price_cents)

      if catalog.price.price_cents == suggested_price.price_cents
        catalog.prices << Price.build(price_cents: suggested_price_cents,
                                      category: :price)
      end

      prices << Price.build(price_cents: cost_price_cents, category: :unit_cost)
      prices << Price.build(price_cents: suggested_price_cents, category: :suggested)
    end

    sig { params(product_id: Integer, profit_rate: Float).returns(String) }
    def self.calculate_profit(product_id, profit_rate)
      cost_price_cents = cost_price_cents_from_product_id product_id
      cost_price_cents += T.must(cost_price_cents).percent_from(profit_rate)
      round_price(Money.new(cost_price_cents)).to_s
    end

    sig do
      params(product: {
               'profit_rate' => T.any(Integer, BigDecimal, Float),
               'total_items' => Integer,
               'items' => T::Array[{
                 'stock_id' => Integer,
                 'measure' => { 'quantity' => T.any(Integer, BigDecimal, Float), 'unit_id' => Integer }
               }]
             }).returns({ cost_price: String, suggested_price: String })
    end
    def self.calculate_prices(product)
      price_cents_for_items = price_for_items_quantity product
      percentage_cents = product['profit_rate'].percent_from(price_cents_for_items)
      suggested_price = Money.new(price_cents_for_items + percentage_cents)
      { cost_price: Money.new(price_cents_for_items).to_s, suggested_price: round_price(suggested_price).to_s }
    end

    sig { params(price: Money).returns(Money) }
    def self.round_price(price)
      Money.new(price.round_to_nearest_cash_value)
    end

    sig do
      params(product: {
               'profit_rate' => T.any(Integer, BigDecimal, Float),
               'total_items' => Integer,
               'items' => T::Array[{
                 'stock_id' => Integer,
                 'measure' => {
                   'quantity' => T.any(Integer, BigDecimal, Float),
                   'unit_id' => Integer
                 }
               }]
             }).returns(Integer)
    end
    def self.price_for_items_quantity(product)
      return 0 unless product['total_items'].positive?

      stocks = stock_by_ids(product['items'].pluck('stock_id'))

      return 0 if stocks.empty?

      cost_price = 0
      product['items'].each do |item|
        stock = stocks.find { |s| s.id == item['stock_id'] }
        raise ActiveRecord::RecordNotFound, I18n.t('errors.messages.missing_item') if stock.nil?

        measure = build_item_measure item
        cost_price += calculate_price_based_on_total_items_and_quantity measure.quantity, product['total_items'], stock
      end

      cost_price
    end

    sig do
      params(item: { 'stock_id' => Integer,
                     'measure' => Hash }).returns(Measure)
    end
    def self.build_item_measure(item)
      Measure.new(unit_id: item['measure']['unit_id']).tap do |measure|
        measure.quantity_converted = item['measure']['quantity']
      end
    end

    sig { params(product_id: Integer).returns(Integer) }
    def self.cost_price_cents_from_product_id(product_id)
      Price.where(priceable_type: Product.name)
           .where(priceable_id: product_id)
           .order(created_at: :desc)
           .pick(:price_cents)
    end

    sig { params(ids: T::Array[Integer]).returns(T.untyped) }
    def self.stock_by_ids(ids)
      Stock.joins(:measure, entries: %i[price quantity_available])
           .eager_load(:measure, entries: %i[price])
           .where(id: ids)
           .where('quantity_availables_entries.quantity > 0')
    end

    sig { params(quantity: BigDecimal, total_items: Integer, stock: Stock).returns(Integer) }
    def self.calculate_price_based_on_total_items_and_quantity(quantity, total_items, stock)
      ((quantity / total_items) * (T.must(recent_entry(stock).price).price_cents / T.must(stock.measure).quantity))
        .ceil
    end

    sig { params(stock: Stock).returns(Entry) }
    def self.recent_entry(stock)
      stock.entries.recent.first!
    end

    private_class_method :cost_price_cents_from_product_id,
                         :round_price,
                         :price_for_items_quantity,
                         :build_item_measure,
                         :stock_by_ids,
                         :calculate_price_based_on_total_items_and_quantity,
                         :recent_entry
  end
end
# rubocop:enable Metrics/MethodLength
