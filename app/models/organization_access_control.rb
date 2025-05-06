# frozen_string_literal: true
# typed: true

# Model
class OrganizationAccessControl < ApplicationRecord
  belongs_to :controlable, polymorphic: true
end
