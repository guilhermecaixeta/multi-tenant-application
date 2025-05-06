# frozen_string_literal: true
# typed: true

# Model
class UserRole < ApplicationRecord
  self.primary_key = %i[user_id role_id]

  belongs_to :user
  belongs_to :role
end
