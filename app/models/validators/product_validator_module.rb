# frozen_string_literal: true
# typed: true

# Validator Module
module ProductValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :measure,
                     :cost_price,
                     :suggested_price,
                     presence: true

    record.validates :total_items,
                     presence: true,
                     numericality: { greater_than_or_equal_to: 1 }

    record.validates_associated :measure,
                                :cost_price,
                                :suggested_price

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_if_has_product_sales]
  end

  private

  sig { void }
  def check_if_has_product_sales
    return if validation_context != :delete

    return unless product_sale_items.exists?

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Product.model_name.human,
                               reason: I18n.t('errors.messages.reasons.has_sales'))
  end
end
