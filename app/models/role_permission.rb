# frozen_string_literal: true
# typed: true

# Model
class RolePermission < ApplicationRecord
  belongs_to :permission
  belongs_to :role
end
