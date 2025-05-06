# frozen_string_literal: true
# typed: true

# Policy
class OrganizationPermissionPolicy < ApplicationPolicy
  def permitted_attributes
    %i[organization_id
       role_id]
  end
end
