# frozen_string_literal: true
# typed: true

# Validator Module
module OrganizationValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :name,
                     presence: true,
                     length: { minimum: 3, maximum: 255 }

    record.validates :domain,
                     presence: true,
                     length: { minimum: 3, maximum: 255 }

    record.validates :email,
                     presence: true,
                     length: { minimum: 8, maximum: 255 },
                     format: { with: URI::MailTo::EMAIL_REGEXP,
                               message: I18n.t('errors.messages.invalid') },
                     uniqueness: { case_sensitive: false }

    record.validates :government_number,
                     length: { maximum: 32 }

    record.validates_associated :organization_roles,
                                :organization_permissions,
                                :organization_addresses,
                                :organization_phones

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_if_has_users]
  end

  private

  sig { void }
  def check_if_has_users
    return if validation_context != :delete

    return unless OrganizationUser.exists?(organization_id: id)

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Organization.model_name.human,
                               reason: I18n.t('errors.messages.reasons.has_users'))
  end
end
