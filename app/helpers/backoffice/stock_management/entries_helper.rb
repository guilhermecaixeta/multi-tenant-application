# frozen_string_literal: true

module Backoffice
  module StockManagement
    module EntriesHelper
      def stocks_for_selection
        Stock.select(:id, :name).order(:name)
      end
    end
  end
end
