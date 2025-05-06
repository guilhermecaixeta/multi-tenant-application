# frozen_string_literal: true
# typed: true

# Validator Module
module AccessControlValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :active_from,
                     presence: true,
                     comparison: { greater_than_or_equal_to: Time.zone.today.to_date },
                     if: proc { |model|
                           validation_context == :create || model.active_from_changed?
                         }

    record.validates :active_until,
                     comparison: { greater_than: :active_from },
                     if: proc { |model|
                           model.active_from.present? && model.active_until.present? && model.active_until_changed?
                         }

    record.validates :active_until,
                     comparison: { greater_than: Time.zone.today.to_date },
                     if: proc { |model|
                           model.active_until.present? && model.active_until_changed?
                         }
  end
end
