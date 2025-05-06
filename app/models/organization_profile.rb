# frozen_string_literal: true
# typed: true

# Organization Profile
class OrganizationProfile < ApplicationRecord
  extend T::Sig

  belongs_to :organization

  has_rich_text :about
end
