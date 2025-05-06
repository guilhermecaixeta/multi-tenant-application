# frozen_string_literal: true

# typed = true

# Policy
class PhonePolicy < ApplicationPolicy
  def permitted_attributes
    %i[country_code
       phone_number
       _destroy]
  end
end
