# frozen_string_literal: true
# typed: true

# Controller
module Backoffice
  module StockManagement
    class EntriesController < BackofficeController
      protected

      def build_dependencies
        @object.build_price(category: Price.categories[:price]) if @object.price.nil?
        @object.build_quantity_available
      end
    end
  end
end
