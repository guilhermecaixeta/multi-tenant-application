# frozen_string_literal: false
# typed: true

if defined?(Rails::Server)
  Rails.logger.debug '=> Setting up application'
  if Rails.env.production?
    system('bin/rails prod:setup')
  else
    Rails.logger.debug '-- Skipping --'
  end
end
