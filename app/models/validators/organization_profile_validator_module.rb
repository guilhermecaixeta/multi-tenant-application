# frozen_string_literal: true
# typed: true

# Organization Profile Validator
module OrganizationProfileValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record)
    super

    record.validates :slogan,
                     presence: true,
                     length: { minimum: 10, maximum: 255 }

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_about_contents]
  end

  private

  MAX_LENGTH = 800
  MIN_LENGTH = 10

  def check_about_contents
    return if validation_context == :delete

    errors.add(:about, I18n.t('errors.messages.blank')) if about.blank?
    errors.add(:about, I18n.t('errors.messages.can_not_be_attached')) if about.embeds.any?

    errors.add(:about, I18n.t('errors.messages.too_long', count: MAX_LENGTH)) if about.to_plain_text.size > MAX_LENGTH

    return if about.to_plain_text.size > MIN_LENGTH

    errors.add(:about, I18n.t('errors.messages.too_short', count: MIN_LENGTH))
  end
end
