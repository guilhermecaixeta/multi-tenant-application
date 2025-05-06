# frozen_string_literal: true

module Backoffice
  module SalesManagement
    module ProductSaleItemsHelper
      def categories_for_selection
        ProductSaleItem.categories.map do |k, _v|
          OpenStruct.new(name: ProductSaleItem.human_attribute_name("category.#{k}"),
                         id: k)
        end
      end

      def products_for_selection
        Catalog.products.select(:id, :name).order(:name)
      end
    end
  end
end
