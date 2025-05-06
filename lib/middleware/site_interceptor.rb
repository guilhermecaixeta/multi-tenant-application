# frozen_string_literal: true
# typed: true

# Middleware module
module Middleware
  # Interceptor
  class SiteInterceptor
    def initialize(app)
      @app = app
    end

    def call(env)
      @req = ActionDispatch::Request.new env

      return @app.call(env) if /(backoffice|rails|assets|up|health)/.match?(@req.env['PATH_INFO'])

      Rails.logger.info { 'Starting to check if there is any tenant for the current request' }

      organization_id = organization_id_by_domain

      @req.session[:site_organization_id] = organization_id if organization_id.present?

      Rails.logger.info { 'Ending check' }

      @app.call(env)
    end

    private

    def request_domain
      case [@req.domain.present?, @req.subdomain.present?]
      when [true, true]
        domain = @req.subdomain.split('.').last
        Rails.logger.info { "Domain found: '#{domain}'" }
        domain
      when [true, false]
        domain = @req.domain.split('.').first
        Rails.logger.info { "Domain found: '#{domain}'" }
        domain
      else
        Rails.logger.info { 'No domain was found' }
        String.new
      end
    end

    def organization_id_by_domain
      return Organization.first&.id unless Rails.env.production?

      domain = request_domain

      domain_id = Organization.where('domain LIKE ?', "#{domain}%").pick(:id) if domain.present?

      Rails.logger.info { 'Tenant found' } if domain_id
      Rails.logger.info { 'Tenant not found' } unless domain_id
      domain_id
    end
  end
end
