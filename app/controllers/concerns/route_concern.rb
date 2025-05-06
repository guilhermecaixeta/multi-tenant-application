# frozen_string_literal: true

module RouteConcern
  extend ActiveSupport::Concern

  included do
    def default_path_for_user(user, fallback_route)
      root_path if user.admin

      fallback_route
    end
  end
end
