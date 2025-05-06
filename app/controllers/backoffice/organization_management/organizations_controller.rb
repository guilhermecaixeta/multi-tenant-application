# frozen_string_literal: true

module Backoffice
  module OrganizationManagement
    class OrganizationsController < BackofficeController
      def select
        respond_to do |format|
          format.html do
            load_all_paginated
            render_selection
          end
        end
      end

      def unselect
        respond_to do |format|
          format.html do
            session.delete(:organization_id)
            redirect_back fallback_location: default_path,
                          notice: t('backoffice.organization.unselected')
          end
        end
      end

      protected

      def includes_associations(model)
        model.eager_load(:organization_profile, :access_control)
      end

      private

      def render_selection
        if set_organization_id_on_session?
          redirect_back fallback_location: default_path,
                        notice: t('backoffice.organization.selected')
        else
          flash.now.alert = t 'backoffice.organization.not_found'
          render :index, status: :not_found
        end
      end

      def set_organization_id_on_session?
        return false unless Organization.exists?(id: params[:id])

        session[:organization_id] = params[:id]
      end
    end
  end
end
