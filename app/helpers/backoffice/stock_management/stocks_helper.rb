# frozen_string_literal: true

module Backoffice
  module StockManagement
    module StocksHelper
      def units_for_selection
        Unit.select(:long_name, :id).order(:id)
      end
    end
  end
end
