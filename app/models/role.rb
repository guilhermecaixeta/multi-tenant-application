# frozen_string_literal: true
# typed: true

# Role Model
class Role < ApplicationRecord
  extend T::Sig

  has_many :user_roles

  has_many :role_permissions

  has_many :users,
           through: :user_roles

  has_many :permissions,
           through: :role_permissions

  def permission?(scope)
    permissions.any? do |permission|
      permission.scope.casecmp?(scope)
    end
  end

  protected

  sig { returns(T::Array[Symbol]) }
  def apply_default_validations_on
    %i[delete]
  end
end
