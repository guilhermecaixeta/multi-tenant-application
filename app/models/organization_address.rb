# frozen_string_literal: true
# typed: true

# Model
class OrganizationAddress < ApplicationRecord
  belongs_to :organization
  belongs_to :address

  accepts_nested_attributes_for :address,
                                reject_if: lambda { |attributes|
                                             attributes['street'].blank? ||
                                               attributes['city'].blank? ||
                                               attributes['state'].blank? ||
                                               attributes['postal_code'].blank?
                                           },
                                allow_destroy: true
end
