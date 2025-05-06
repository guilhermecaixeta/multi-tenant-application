# frozen_string_literal: true
# typed: true

module Backoffice
  module UserSettings
    # Passwords Controller
    class PasswordsController < BackofficeController
      def update
        respond_to do |format|
          if @object.update_with_password(permitted_params)
            format.html do
              redirect_to default_path
            end
          else
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      protected

      def model_klass_policy
        PasswordPolicy
      end

      def model_klass_name
        User.name
      end

      def find_or_build_model
        @object ||= current_user
      end

      def default_path
        root_path
      end
    end
  end
end
