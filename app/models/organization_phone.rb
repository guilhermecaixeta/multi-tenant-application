# frozen_string_literal: true
# typed: true

# Model
class OrganizationPhone < ApplicationRecord
  belongs_to :organization
  belongs_to :phone

  accepts_nested_attributes_for :phone,
                                reject_if: ->(attributes) { attributes['phone_number'].blank? },
                                allow_destroy: true
end
