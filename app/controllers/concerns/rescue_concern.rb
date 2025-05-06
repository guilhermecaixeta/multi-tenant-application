# frozen_string_literal: true
# typed: true

# Rescue module
module RescueConcern
  extend ActiveSupport::Concern

  included do
    rescue_from DomainErrors::BadRequestError do |e|
      raise unless Rails.env.production? || Rails.env.test?

      Rails.logger.error(e)

      flash[:alert] = e.message if e.present?
      redirect_back fallback_location: default_path, status: :bad_request
    end

    rescue_from DomainErrors::UnprocessableEntityError do |e|
      raise unless Rails.env.production? || Rails.env.test?

      Rails.logger.error(e)

      flash[:alert] = e.message if e.present?
      redirect_back fallback_location: default_path, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      raise unless Rails.env.production? || Rails.env.test?

      Rails.logger.error(e)

      flash[:alert] = e.message if e.present?
      redirect_back fallback_location: default_path, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      raise unless Rails.env.production? || Rails.env.test?

      Rails.logger.error(e)

      flash[:alert] = e.message if e.present?

      redirect_back fallback_location: default_path, status: :not_found
    end

    rescue_from Pundit::NotAuthorizedError do |e|
      Rails.logger.error(e)

      redirect_to backoffice_forbidden_path
    end
  end
end
