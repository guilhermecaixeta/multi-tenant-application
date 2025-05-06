# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :layout_by_resource

  include RouteConcern
  include Pagy::Backend

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :user
      'authentication'
    else
      'application'
    end
  end

  def after_sign_in_path_for(_resource)
    backoffice_path
  end

  def after_sign_out_path_for(_resource)
    sign_in_path
  end

  def sign_out_and_redirect(_resource)
    sign_in_path
  end
end
