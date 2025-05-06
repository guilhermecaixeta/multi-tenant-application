# frozen_string_literal: true
# typed: true

# Categories Controller
module Site
  # Menu Controller
  class MenuController < SiteController
    def index
      redirect_to root_path if @categories.blank?
      category_key = t('routes.site.params.menu.category').to_sym
      @category = params.require(category_key) if params[category_key]
      nil unless session[:site_organization_id]
    end
  end
end
