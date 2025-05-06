# frozen_string_literal: true

module Backoffice
  module SalesManagement
    class ProductSaleItemsController < BackofficeController
      def new
        render :new
      end

      def destroy
        render :destroy
      end

      protected

      def permitted_params
        permitted_attributes = ProductSalePolicy.new(model_klass,
                                                     controller_path).permitted_attributes
        params.require(:product_sale_items).permit(permitted_attributes)
      end

      def find_or_build_model
        @object = ProductSale.new
        @object.product_sale_items.build(use_default_price: false)
        @object.product_sale_items.each do |psi|
          psi.build_price(category: :price)
        end

        @object.build_sale
        @object.sale.build_expenses(category: Price.categories[:other]) if @object.sale.expenses.nil?

        @object
      end

      def model_klass_service; end
    end
  end
end
