# frozen_string_literal: true
# typed: true

# Policy
class AccessControlPolicy < ApplicationPolicy
  extend T::Sig

  sig { returns(T::Array[Symbol]) }
  def permitted_attributes
    %i[id
       active
       active_from
       active_until]
  end
end
