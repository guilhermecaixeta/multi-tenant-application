# frozen_string_literal: true

# typed = true

# Policy
class ProfilePolicy < ApplicationPolicy
  def permitted_attributes
    [:first_name,
     :last_name,
     :middle_name,
     :birthdate,
     :avatar,
     { address_attributes: AddressPolicy.new(user, record).permitted_attributes,
       phone_attributes: PhonePolicy.new(user, record).permitted_attributes }]
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve; end
  end
end
