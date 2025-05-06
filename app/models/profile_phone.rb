# frozen_string_literal: true
# typed: true

# Model
class ProfilePhone < ApplicationRecord
  belongs_to :profile
  belongs_to :phone
end
