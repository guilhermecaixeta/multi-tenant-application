# frozen_string_literal: true

# typed = true

# Policy
class AddressPolicy < ApplicationPolicy
  def permitted_attributes
    %i[street
       compliment
       city
       state
       postal_code
       _destroy]
  end
end
