# frozen_string_literal: true
# typed: true

# rubocop:disable Rails/SkipsModelValidations

# After Sales Concern
module RebalanceStockConcern
  extend T::Sig
  extend ActiveSupport::Concern

  include DomainErrors

  included do
    sig { params(product_id: Integer, total_items: Integer).void }
    def self.rebalance_from_product_id(product_id, total_items)
      return if total_items.zero?

      find_stock_by_catalogable_id(product_id).find_each do |stock|
        total_amount = stock.items.sum(&:measure_by_unit) * total_items.abs
        total_amount = BigDecimal(total_amount.round) if stock.measure.unit.decimal?

        if total_items.positive?
          increase_stock_balance(stock, total_amount)
        else
          decrease_stock_balance(stock, total_amount)
        end
      end
    end

    sig { params(catalogable_id: Integer).returns(T.untyped) }
    def self.find_stock_by_catalogable_id(catalogable_id)
      Stock
        .joins(:quantity_available,
               :measure,
               items: [:catalog, { measure: :unit }])
        .includes(:quantity_available,
                  items: [:catalog, { measure: :unit }])
        .where(catalog: { catalogable_id: })
        .references(:catalog)
    end

    sig { params(stock: Stock, value: BigDecimal).void }
    def self.increase_stock_balance(stock, value)
      result = value + T.must(stock.quantity_available).quantity
      if result.to_f > stock.quantity_total.to_f
        log_and_raise_error
      else
        T.must(stock.quantity_available).increment!(:quantity, value.to_i)
      end
    end

    sig { params(stock: Stock, value: BigDecimal).void }
    def self.decrease_stock_balance(stock, value)
      if value.to_f > T.must(stock.quantity_available).quantity.to_f
        log_and_raise_error
      else
        T.must(stock.quantity_available).decrement!(:quantity, value.to_i)
      end
    end

    def self.log_and_raise_error
      Rails.logger.error { I18n.t('errors.messages.stock_insuficient_quantity') }
      raise InsufficientBalanceError
    end

    private_class_method :find_stock_by_catalogable_id,
                         :increase_stock_balance,
                         :decrease_stock_balance,
                         :log_and_raise_error
  end
end
# rubocop:enable Rails/SkipsModelValidations
