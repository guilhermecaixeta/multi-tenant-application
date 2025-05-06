# frozen_string_literal: true

module Backoffice
  module CatalogsManagement
    module ProductsHelper
      def stocks_for_selection_for_products
        Stock.joins(:quantity_available)
             .select(:name, :id).order(:name)
      end

      def categories_for_selection_for_products
        Category.select(:name, :id).order(:name)
      end

      def catalog_categories_for_selection
        CatalogCategory.select(:id, :title).order(:title)
      end
    end
  end
end
