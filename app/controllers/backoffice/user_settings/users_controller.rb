# frozen_string_literal: true

module Backoffice
  module UserSettings
    # Users Controller
    class UsersController < BackofficeController
      before_action :previous_change_action_url,
                    only: %i[edit_profile edit_security]

      def edit_profile; end

      def update_profile
        update
      end

      protected

      def build_dependencies
        @object.build_profile unless @object.profile
        @object.build_access_control unless @object.access_control
      end

      def find_or_build_model
        if action_name == 'new' || action_name == 'edit' || action_name == 'create' || action_name == 'update'
          return super
        end

        @object = current_user
      end

      def default_path
        session[:previous_change_action_url] || super
      end

      def includes_associations(model)
        model
          .select(:id, :email)
          .joins(:profile)
          .left_outer_joins(profile: :avatar_attachment)
          .eager_load(:access_control,
                      :profile,
                      profile: :avatar_attachment)
      end
    end
  end
end
