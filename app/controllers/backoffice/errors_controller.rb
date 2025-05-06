# frozen_string_literal: true

module Backoffice
  # Errors Controller
  class ErrorsController < BackofficeController
    def forbidden
      render status: :forbidden
    end

    def not_found
      render status: :not_found
    end

    def internal_error
      render status: :internal_server_error
    end

    def unacceptable
      render status: :unacceptable
    end

    protected

    def model_class
      ''
    end

    def find_or_build_model
      nil
    end
  end
end
