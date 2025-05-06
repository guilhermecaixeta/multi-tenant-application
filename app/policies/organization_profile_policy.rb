# frozen_string_literal: true
# typed: true

# Policy
class OrganizationProfilePolicy < ApplicationPolicy
  def permitted_attributes
    %i[id
       slogan
       about
       organization_id]
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      []
    end
  end
end
