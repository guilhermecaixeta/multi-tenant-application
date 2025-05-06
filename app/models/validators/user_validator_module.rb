# frozen_string_literal: true
# typed: true

# Validator Module
module UserValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :email,
                     presence: true,
                     length: { minimum: 8, maximum: 128 },
                     format: { with: URI::MailTo::EMAIL_REGEXP,
                               message: I18n.t('errors.messages.invalid') },
                     uniqueness: { case_sensitive: false }

    record.validates :password,
                     password_strength: true,
                     confirmation: true,
                     if: [proc { |r| r.password.present? }]

    record.validates_associated :profile

    record.validates :profile, presence: true

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_current_password
       check_password_confirmation_equality
       check_passwords_fillment
       check_password_strength]
  end

  private

  def check_current_password
    return unless validation_context == :password_update

    return unless Devise::Encryptor.compare(self.class, encrypted_password_was, password)

    errors.add(:password,
               :password_equals,
               message: I18n.t('errors.messages.password.equals_last_password'))
  end

  def check_password_confirmation_equality
    return unless validation_context == :password_update

    return unless password != password_confirmation

    errors.add(:password_confirmation,
               :passwords_does_not_matches,
               message: I18n.t('errors.messages.password.unmatched'))
  end

  def check_password_strength
    return unless validation_context == :password_update

    strong_password_checker = StrongPassword::StrengthChecker.new

    return unless strong_password_checker.is_weak? password

    errors.add(:password,
               :password_is_weak,
               message: I18n.t('errors.messages.password.weak'))
  end

  def check_passwords_fillment
    return if validation_context == :delete

    case [password.blank?, password_confirmation.blank?]
    when [true, false]
      errors.add :password,
                 I18n.t('errors.messages.blank')
    when [false, true]
      errors.add :password_confirmation,
                 I18n.t('errors.messages.blank')
    end
  end

  private_class_method :custom_validators
end
