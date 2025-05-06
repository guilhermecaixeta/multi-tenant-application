# frozen_string_literal: true
# typed: true

# Policy
class OrganizationAddressPolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :code,
     :name,
     :domain,
     :email,
     :government_number,
     { organization_role_attributes: OrganizationRolePolicy.new(user, record).permitted_attributes,
       organization_phones_attributes: OrganizationPhonePolicy.new(user,
                                                                   record).permitted_attributes,
       organization_addresses_attributes: OrganizationAddressPolicy.new(user,
                                                                        record).permitted_attributes,
       organization_permissions_attributes: OrganizationPermissionPolicy.new(user,
                                                                             record).permitted_attributes }]
  end
end
