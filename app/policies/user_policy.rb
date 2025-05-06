# frozen_string_literal: true
# typed: true

# Policy
class UserPolicy < ApplicationPolicy
  extend T::Sig

  sig { returns(T::Array[Symbol]) }
  def permitted_attributes
    return user_attributes if can_access?(record.action_name) && record.action_name != 'update_profile'

    user_profile_attributes
  end

  sig { params(action: String).returns(T::Boolean) }
  def can_access?(action = nil)
    scope = "#{record.controller_path}/#{action}".camelize if action
    Rails.logger.info { "Checking permission for resource '#{scope || current_scope}'" }

    has_access = user.roles.any? { |role| role.permission?(scope || current_scope) }

    if has_access
      Rails.logger.info { "Permission to resource '#{current_scope}': granted" }
    else
      Rails.logger.warn { "Permission to resource '#{current_scope}': denied" }
    end

    has_access
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      User.joins(:profile)
          .left_outer_joins(profile: :avatar_attachment)
          .eager_load(profile: :avatar_attachment)
          .select('users.id',
                  'users.email',
                  "concat_ws(' ', profiles.first_name, profiles.last_name) as profile_name",
                  'users.last_sign_in_at')
          .where.not(users: { id: @user.id })
          .order('profile_name')
    end
  end

  private

  def user_attributes
    [:email,
     :password,
     :organization_ids,
     :password_confirmation,
     { role_ids: [],
       access_control_attributes: AccessControlPolicy.new(user, record).permitted_attributes,
       profile_attributes: profile_attributes }]
  end

  def user_profile_attributes
    [{ profile_attributes: profile_attributes }]
  end

  def profile_attributes
    %i[id
       first_name
       last_name
       middle_name
       birthdate
       avatar]
  end
end
