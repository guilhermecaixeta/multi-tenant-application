# frozen_string_literal: true
# typed: true

# Authorization Concern Module
module AuthorizationConcern
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    extend T::Sig

    before_action :change_password?
    before_action :can_access?

    helper_method :policy_for

    def permitted_params
      permitted_attributes = model_klass_policy.new(current_user, self).permitted_attributes

      params.require(model_klass_name.underscore.to_sym).permit(permitted_attributes)
    end

    def model_klass_policy
      "#{model_klass_name}Policy".constantize
    end

    def policy_for(user, controller)
      UserPolicy.new(user, controller)
    end

    private

    def can_access?
      return true if controller_name == Backoffice::ErrorsController.controller_name

      authorize self,
                :can_access?,
                policy_class: UserPolicy
    end

    def change_password?
      return false unless current_user.active? &&
                          current_user.force_password_change &&
                          controller_name != Backoffice::UserSettings::PasswordsController.controller_name

      redirect_to edit_security_backoffice_user_settings_users_path,
                  alert: t('devise.failure.force_password_change')
    end
  end
end
