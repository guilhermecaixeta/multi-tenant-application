# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :admin, { permission_ids: [] }]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Role.includes(:permissions)
          .distinct
          .select('roles.id',
                  'roles.name',
                  'roles.admin',
                  'COALESCE((SELECT 1 FROM user_roles WHERE user_roles.role_id = roles.id LIMIT 1) = 0, true) as destroyable')
          .order(:name)
    end
  end
end
