# frozen_string_literal: true
# typed: true

# Validator Module
module RoleValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record)
    super

    record.validates :name,
                     presence: true,
                     uniqueness: { case_sensitive: false },
                     length: { minimum: 3, maximum: 255 }

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_if_is_admin check_if_has_users]
  end

  private

  def check_if_is_admin
    return unless validation_context == :delete

    return unless name.casecmp?(Rails.configuration.x.authorization.default_roles.first[:name])

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Role.model_name.human,
                               reason: I18n.t('errors.messages.reasons.role_admin'))
  end

  def check_if_has_users
    return unless validation_context == :delete

    return unless users.exists?

    errors.add :base,
               :can_not_be_deleted,
               message: I18n.t('errors.messages.can_not_be_deleted',
                               attribute: Role.model_name.human,
                               reason: I18n.t('errors.messages.reasons.has_users'))
  end
end
