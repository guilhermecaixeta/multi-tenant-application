# frozen_string_literal: true
# typed: true

# Validator Module
module CatalogCategoryValidatorModule
  extend T::Sig

  sig { params(record: T::Class[ApplicationRecord]).void }
  def self.included(record) # rubocop:disable Metrics/MethodLength
    super

    record.validates :title,
                     :description,
                     presence: true

    record.validates :title,
                     length: { minimum: 3,
                               maximum: 64 }

    record.validates :default_picture,
                     attached: true,
                     content_type: Rails.configuration.x.attachment.allowed_formats_for_images,
                     size: { less_than: Rails.configuration.x.attachment.max_image_size }

    record.validate(*custom_validators)
  end

  sig { returns(T::Array[Symbol]) }
  def self.custom_validators
    %i[check_description_contents]
  end

  private

  MAX_LENGTH = 400
  MIN_LENGTH = 5

  def check_description_contents
    errors.add(:description, I18n.t('errors.messages.blank')) if description.blank?
    errors.add(:description, I18n.t('errors.messages.can_not_be_attached')) if description.embeds.any?

    if description.to_plain_text.size > MAX_LENGTH
      errors.add(:description, I18n.t('errors.messages.too_long', count: MAX_LENGTH))
    end

    return if description.to_plain_text.size > MIN_LENGTH

    errors.add(:description, I18n.t('errors.messages.too_short', count: MIN_LENGTH))
  end
end
