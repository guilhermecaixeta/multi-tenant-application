# frozen_string_literal: true
# typed: true

# Policy
class OrganizationPhonePolicy < ApplicationPolicy
  def permitted_attributes
    [:organization_id,
     :phone_id,
     { phone_attributes: PhonePolicy.new(user, record).permitted_attributes }]
  end
end
