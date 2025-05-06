# frozen_string_literal: true
# typed: true

# rubocop:disable Metrics/BlockLength

# Rebalance Entries Concern
module RebalanceEntriesConcern
  extend T::Sig
  extend ActiveSupport::Concern

  include DomainErrors

  included do
    sig { params(product_id: Integer, total_items: Integer).void }
    def self.rebalance_from_product_id(product_id, total_items)
      return if total_items.zero?

      grouped_entries = find_entries_grouped_by_stock_id_from_product_id(product_id)
      if total_items.positive?
        update_balance(grouped_entries, BigDecimal(total_items.abs), proc { |e, i| increase_entry_balance(e, i) })
      else
        update_balance(grouped_entries, BigDecimal(total_items.abs), proc { |e, i| decrease_entry_balance(e, i) })
      end
    end

    sig { params(product_id: Integer).returns(T::Array[{ total_amount: BigDecimal, entries: T::Array[Entry] }]) }
    def self.find_entries_grouped_by_stock_id_from_product_id(product_id)
      Entry
        .joins(:quantity_available,
               stock: { items: %i[catalog], measure: :unit })
        .includes(:quantity_available,
                  stock: { measure: :unit })
        .where(catalog: { catalogable_id: product_id })
        .references(:catalog)
        .recent
        .group_by(&:stock_id)
        .to_a
        .flat_map do |group_entries|
          { total_amount: product_item_amount_sum(group_entries.first, product_id), entries: group_entries.last }
        end
    end

    sig { params(stock_id: Integer, product_id: Integer).returns(BigDecimal) }
    def self.product_item_amount_sum(stock_id, product_id)
      Item
        .joins(:stock, :catalog, measure: :unit)
        .includes(:catalog, measure: :unit)
        .where(stock: { id: stock_id })
        .where(catalog: { catalogable_id: product_id })
        .references(:stock, :catalog)
        .to_a
        .sum(&:measure_by_unit)
    end

    sig do
      params(grouped_entries: T::Array[{ total_amount: BigDecimal, entries: T::Array[Entry] }],
             total_items: BigDecimal,
             proc: T.proc.params(arg0: Entry, arg1: BigDecimal).returns(BigDecimal)).void
    end
    def self.update_balance(grouped_entries, total_items, proc)
      updated_amounts = []
      grouped_entries.each do |grouped_entry|
        total_amount = grouped_entry[:total_amount] * total_items

        grouped_entry[:entries].each do |entry|
          total_amount = BigDecimal(total_amount.round) if entry.stock.measure.unit.decimal?
          total_amount = proc.call(entry, total_amount)
          updated_amounts << T.must(entry.quantity_available).attributes
        end
        log_and_raise_error if total_amount.positive?
      end

      update_measures updated_amounts
    end

    sig { params(entry: Entry, total_amount: BigDecimal).returns(BigDecimal) }
    def self.increase_entry_balance(entry, total_amount)
      balance_updated = T.must(T.must(entry.quantity_available).quantity) + total_amount

      if balance_updated > entry.quantity_total
        T.must(entry.quantity_available).quantity = entry.quantity_total
        balance_updated - entry.quantity_total
      else
        T.must(entry.quantity_available).quantity += total_amount
        BigDecimal(0)
      end
    end

    sig { params(entry: Entry, total_amount: BigDecimal).returns(BigDecimal) }
    def self.decrease_entry_balance(entry, total_amount)
      balance_updated = T.must(entry.quantity_available).quantity

      if total_amount > balance_updated
        T.must(entry.quantity_available).quantity = BigDecimal(0)
        total_amount - balance_updated
      else
        T.must(entry.quantity_available).quantity -= total_amount
        BigDecimal(0)
      end
    end

    sig { params(measures: T::Array[Hash]).void }
    def self.update_measures(measures)
      Measure.upsert_all measures, # rubocop:disable Rails/SkipsModelValidations
                         update_only: [:quantity],
                         record_timestamps: true
    end

    sig { void }
    def self.log_and_raise_error
      Rails.logger.error { I18n.t('errors.messages.stock_insuficient_quantity') }
      raise InsufficientBalanceError
    end

    private_class_method :find_entries_grouped_by_stock_id_from_product_id,
                         :product_item_amount_sum,
                         :update_measures,
                         :increase_entry_balance,
                         :decrease_entry_balance,
                         :log_and_raise_error
  end
end

# rubocop:enable Metrics/BlockLength
