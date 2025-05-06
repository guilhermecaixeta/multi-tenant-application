# frozen_string_literal: true
# typed: true

# Controller
module Backoffice
  module StockManagement
    class StocksController < BackofficeController
      def new
        super
        @object.build_measure
      end
    end
  end
end
