# frozen_string_literal: true
# typed: true

# Model
class OrganizationUser < ApplicationRecord
  self.primary_key = %i[user_id organization_id]

  belongs_to :user
  belongs_to :organization
end
