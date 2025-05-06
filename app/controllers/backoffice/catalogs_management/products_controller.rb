# frozen_string_literal: true
# typed: true

# Controller class
module Backoffice
  module CatalogsManagement
    class ProductsController < BackofficeController
      def policy_scope(_klass)
        super(Product)
      end

      def recalculate_prices
        @object.product.recalculate_prices

        redirect_back fallback_location: default_path,
                      notice: t('backoffice.message_recalculated',
                                model_name: model_klass.model_name.human)
      end

      def calculate_prices
        respond_to do |format|
          format.json do
            render json: Product.calculate_prices(permitted_params.to_h)
          end
        end
      end

      def calculate_profit_price
        profit_rate = params[:profit_rate].to_f
        product_id = params[:id].to_i

        respond_to do |format|
          format.all do
            render json: { price: Product.calculate_profit(product_id, profit_rate) }
          end
        end
      end

      protected

      def model_klass
        Catalog
      end

      def permitted_params
        if action_name == 'calculate_prices'
          super
        else
          permitted_attributes = CatalogPolicy.new(current_user, self).permitted_attributes
          params.require(:catalog).permit(permitted_attributes)
        end
      end

      def find_or_build_model
        @object = if params&.key?(:id)
                    includes_associations(model_klass).find(params[:id])
                  else
                    model_klass.new(catalogable: Product.new)
                  end
        @object
      end

      def build_dependencies
        @object.build_price(category: Price.categories[:price]) if @object
                                                                   .price
                                                                   .nil?
        build_product_associations @object.product
        build_items_associations @object.items
      end

      private

      def build_product_associations(product)
        product.build_cost_price(category: Price.categories[:unit_cost]) if product
                                                                            .cost_price
                                                                            .nil?

        product.build_suggested_price(category: Price.categories[:suggested]) if product
                                                                                 .suggested_price
                                                                                 .nil?

        product.build_measure(kind: Measure.kinds[:total]) unless product.measure
      end

      def build_items_associations(items)
        return if items.any?

        items.build unless items.any?
        items.each do |i|
          i.build_measure(kind: Measure.kinds[:total]) unless i.measure
        end
      end
    end
  end
end
