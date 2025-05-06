# frozen_string_literal: true

class PermissionPolicy < ApplicationPolicy
  def permitted_attributes
    raise 'Not allowed create or update any value'
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Permission.all
    end
  end
end
