# frozen_string_literal: true
# typed: true

# Policy
class PasswordPolicy < ApplicationPolicy
  def permitted_attributes
    %i[current_password password password_confirmation]
  end
end
