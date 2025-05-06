# frozen_string_literal: true
# typed: true

# Validator Module
module ProductSaleValidatorModule
  extend T::Sig

  sig { params(record: Module).void }
  def self.included(record)
    super

    record.validates :product_sale_items,
                     presence: true,
                     length: { minimum: 1,
                               message: I18n.t('errors.messages.array_min_size', count: 1) }

    record.validates_associated :sale,
                                :product_sale_items

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_available_balance]
  end

  private

  def check_available_balance
    return if validation_context == :delete

    self.product_sale_items
        .find_all { |psi| !psi.total_items.nil? }
        .find_all(&:sale?)
        .group_by(&:product_id)
        .each do |group|
      sum_of_total_items = group.last.sum(&:total_items)
      product_sale_item = T.must(group.last.first)

      check_balance(product_sale_item, sum_of_total_items)
    end
  end

  def check_balance(product_sale_item, sum_of_total_items)
    return if validation_context == :delete

    stock_by_product_id(product_sale_item.product_id).find_each do |stock|
      sum_of_measures = stock.items.sum(&:measure_by_unit) * sum_of_total_items

      next unless sum_of_measures >= T.must(T.must(stock.quantity_available).quantity)

      errors.add :base,
                 :insufficient_quantity,
                 message: I18n.t('errors.messages.stock_insuficient_quantity')
    end
  end

  def stock_by_product_id(catalogable_id)
    Stock
      .joins(:quantity_available,
             :measure,
             items: %i[catalog measure],
             entries: [:quantity_available])
      .includes(:quantity_available,
                items: %i[catalog measure],
                entries: [:quantity_available])
      .where(catalog: { catalogable_id: })
      .references(:catalog)
  end
end
