# frozen_string_literal: true

module Backoffice
  module OrganizationManagement
    # Organization Profile Controller
    class OrganizationProfilesController < BackofficeController
      protected

      def default_path
        root_path
      end

      def find_or_build_model
        @object = OrganizationProfile.eager_load(:organization, :rich_text_about)
                                     .left_outer_joins(:rich_text_about)
                                     .where(organization: { code: Apartment::Tenant.current.sub('organization_', '') })
                                     .references(:organization)
                                     .first
      end
    end
  end
end
