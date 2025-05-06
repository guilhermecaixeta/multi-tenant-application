# frozen_string_literal: true

module Backoffice
  module ApplicationManagement
    module RolesHelper
      def permission_options
        Permission.select(:id, :scope).order(:scope)
      end
    end
  end
end
