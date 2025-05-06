# frozen_string_literal: true
# typed: true

# Stock Validator Module
module StockValidatorModule
  extend T::Sig

  sig { params(record: Module).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :measure,
                     presence: true

    record.validates :name,
                     presence: true,
                     length: { minimum: 3, maximum: 255 }

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_if_has_entries check_if_has_items]
  end

  private

  sig { void }
  def check_if_has_entries
    return unless validation_context == :delete

    return unless Entry.exists?(stock_id: id)

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Stock.model_name.human,
                               reason: I18n.t('errors.messages.reasons.has_entries'))
  end

  sig { void }
  def check_if_has_items
    return unless validation_context == :delete

    return unless Item.exists?(stock_id: id)

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Stock.model_name.human,
                               reason: I18n.t('errors.messages.reasons.has_items'))
  end

  private_class_method :custom_validators
end
