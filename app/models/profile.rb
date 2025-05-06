# frozen_string_literal: true
# typed: true

# Model
class Profile < ApplicationRecord
  extend T::Sig

  belongs_to :user

  has_one_attached :avatar

  has_many :profile_addresses

  has_many :profile_phones

  has_many :addresses,
           through: :profile_addresses

  has_many :phones,
           through: :profile_phones

  validates :first_name,
            presence: true,
            length: { minimum: 3, maximum: 255 }

  validates :last_name,
            presence: true,
            length: { minimum: 3, maximum: 255 }

  validates :middle_name,
            length: { minimum: 3, maximum: 255 },
            if: [proc { |r| r.middle_name && r.middle_name.present? }]

  validates :birthdate,
            presence: true

  validates :avatar,
            content_type: Rails.configuration.x.attachment.allowed_formats_for_images,
            size: { less_than: Rails.configuration.x.attachment.max_image_size },
            if: -> { avatar&.attached? }

  accepts_nested_attributes_for :addresses,
                                :phones,
                                allow_destroy: true

  sig { returns(String) }
  def full_name
    "#{first_name} #{last_name}"
  end
end
