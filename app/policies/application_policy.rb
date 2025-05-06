# frozen_string_literal: true
# typed: true

# Application Policy
class ApplicationPolicy
  extend T::Sig

  attr_reader :user, :record

  sig { params(user: User, record: T.anything).void }
  def initialize(user, record)
    @user = user
    @record = record
  end

  # Scope class
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  protected

  def current_scope
    return nil unless T.must(record).is_a?(ApplicationController)

    @current_scope ||= "#{record.controller_path}/#{record.action_name}".camelize
  end
end
