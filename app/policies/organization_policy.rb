# frozen_string_literal: true
# typed: true

# Policy
class OrganizationPolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :code,
     :name,
     :logo,
     :email,
     :domain,
     :government_number,
     { access_control_attributes: AccessControlPolicy.new(user, record).permitted_attributes },
     { organization_profile_attributes: OrganizationProfilePolicy.new(user, record).permitted_attributes }]
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      Organization.all
    end
  end
end
