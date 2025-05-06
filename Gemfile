# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# StrongPassword provides entropy-based password strength checking for your apps.
#  https://github.com/bdmac/strong_password
gem 'strong_password', '~> 0.0.9'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# MJML-Rails allows you to render HTML emails from an MJML template.
gem 'mjml-rails'

# Ruby wrapper for MRML, the MJML markup language implementation in Rust.
# Rust must be available on your system to install this gem if you use a version below v1.4.2.
gem 'mrml'

# This library provides integration of the money gem with Rails.
# https://github.com/RubyMoney/money-rails
gem 'money-rails', '~> 1.12'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

# The static type checker
gem 'sorbet-runtime'

# Style
gem 'bootstrap', '>= 5.1.3'

# Process scss
gem 'dartsass-sprockets', '~> 3.1'

# Repository for collecting Locale data for Ruby on Rails I18n as well as other interesting,
# Rails related I18n stuff http://rails-i18n.org
gem 'rails-i18n'

# Enhances simple I18n backend in a way that it inflects translation data using pattern interpolation.
# https://rubydoc.info/gems/i18n-inflector/2.6.6/file/docs/USAGE
gem 'i18n-inflector'

# Auth and Autentication
gem 'devise', '~> 4.9'
gem 'devise-i18n'

# Pundit provides a set of helpers which guide you in leveraging regular Ruby classes and object oriented design
# patterns to build a straightforward, robust, and scalable authorization system.
gem 'pundit'

# Pagination
gem 'pagy', '~> 8.3'

# This is the Mailgun Ruby Library. This library contains methods for easily interacting with the Mailgun API.
# Below are examples to get you started.
# For additional examples, please see our official documentation at https://documentation.mailgun.com
gem 'mailgun-ruby', '~>1.2.14'

gem 'aws-sdk-s3', require: false

# Search Engine Optimization (SEO) plugin for Ruby on Rails applications. https://github.com/kpumuk/meta-tags
gem 'meta-tags'

# SEO improvement
gem 'sitemap_generator'

# Whenever is a Ruby gem that provides a clear syntax for writing and deploying cron jobs.
gem 'whenever', require: false

# Improve url naming
# TODO: add support to url based on locale
# gem 'route_translator'

# Deploy web apps in containers to servers running Docker with zero downtime.
gem 'kamal'

# Multitenancy for Rails and ActiveRecord
gem 'ros-apartment', require: 'apartment'

# Font Awesome has an official Ruby on Rails gem for free and pro icons.
gem 'font-awesome-sass'

# Active Storage validation
gem 'active_storage_validations'

# This gem replaces the normal ERB parsing with an HTML-aware ERB parsing.
# This makes your templates smarter by adding runtime checks around the data interpolated from Ruby into HTML.
gem 'better_html'

# Simple, efficient background processing for Ruby.
gem 'sidekiq', '~> 7.3'

gem 'thruster', require: false

group :development, :test do
  # A normaliser/beautifier for HTML that also understands embedded Ruby. Ideal for tidying up Rails templates.
  gem 'database_cleaner'
  gem 'htmlbeautifier'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails', '~> 6.4'
  # Faker is a port of Perl's Data::Faker library. It's a library for generating fake data such as names,
  # addresses and phone numbers.
  gem 'faker'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rails_refactor'
  gem 'rspec-core', '~> 3.13'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails_config'
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'solargraph'
  gem 'spoom'
  gem 'tapioca', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Better Errors replaces the standard Rails error page with a much better and more useful error page.
  # It is also usable outside of Rails in any Rack app as Rack middleware.
  gem 'better_errors'

  # Code
  gem 'erb_lint', require: false
  gem 'sorbet'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
