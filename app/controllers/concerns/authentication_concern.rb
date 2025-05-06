# frozen_string_literal: true
# typed: true

# Authentication Concern Module
module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    extend T::Sig

    before_action :authenticate_user!

    helper_method :current_organization

    sig { returns(T.nilable(User)) }
    def current_user
      @current_user ||= super.tap do |user|
        return nil unless user

        ActiveRecord::Associations::Preloader
          .new(records: [user], associations: [:roles,
                                               :access_control,
                                               { user_roles: { role: :permissions } },
                                               { organization_users: { organization: %i[access_control
                                                                                        logo_attachment] } },
                                               { profile: :avatar_attachment }]).call
      end
    end

    sig { returns(T.nilable(Organization)) }
    def current_organization
      return nil unless user_signed_in? || current_user&.active?

      @current_organization ||= if session.key?(:organization_id)
                                  Organization.preload(:logo_attachment).find session[:organization_id]
                                else
                                  current_user.principal_organization
                                end
    end
  end
end
