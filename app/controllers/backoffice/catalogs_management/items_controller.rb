# frozen_string_literal: true

module Backoffice
  module CatalogsManagement
    class ItemsController < BackofficeController
      before_action :find_or_build_model, only: %i[new destroy]

      def new
        render :new
      end

      def destroy
        render :destroy
      end

      protected

      def permitted_params
        permitted_attributes = ProductPolicy.new(model_klass, controller_path).permitted_attributes
        params.require(:product).permit(permitted_attributes)
      end

      def find_or_build_model
        @object = Catalog.new(catalogable: Product.new)
        @object.items.build
        @object.items.first.measure = Measure.new
      end

      def model_klass_service; end
    end
  end
end
