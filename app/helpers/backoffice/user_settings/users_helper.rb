# frozen_string_literal: true

module Backoffice
  module UserSettings
    module UsersHelper
      def role_for_selection
        Role.select(:id, :name).order(:name, :admin)
      end

      def organization_for_selection
        Organization.only_active.select(:id, :name)
      end
    end
  end
end
