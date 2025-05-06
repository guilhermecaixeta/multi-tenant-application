# frozen_string_literal: true

module Backoffice
  module SalesManagement
    # Product Sales Controller
    class ProductSalesController < BackofficeController
      protected

      def build_dependencies
        @object.product_sale_items.build(use_default_price: false)
        @object.product_sale_items.each do |psi|
          psi.build_price(category: :price)
        end

        @object.build_sale
        @object.sale.build_expenses(category: Price.categories[:other]) if @object.sale.expenses.nil?

        @object
      end

      def includes_associations(model)
        model.eager_load(:expenses,
                         sale: [:expenses],
                         product_sale_items: [:prices, { product: :catalog }])
      end
    end
  end
end
