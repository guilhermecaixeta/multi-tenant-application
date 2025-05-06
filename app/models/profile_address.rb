# frozen_string_literal: true
# typed: true

# Model
class ProfileAddress < ApplicationRecord
  belongs_to :profile
  belongs_to :address
end
