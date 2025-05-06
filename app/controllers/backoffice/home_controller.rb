# frozen_string_literal: true
# typed: true

module Backoffice
  # Home Controller
  class HomeController < BackofficeController
    def index; end

    protected

    def load_all_paginated; end

    def model_klass; end

    def find_or_build_model; end
  end
end
