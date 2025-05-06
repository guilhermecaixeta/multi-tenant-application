# frozen_string_literal: true

module Backoffice
  module Support
    class UnitsController < BackofficeController
      def select_units_by_stock_id
        respond_to do |format|
          @source_value = permitted_params[:source_value].to_i
          @destination_id = permitted_params[:destination_id]
          @destination_name = permitted_params[:destination_name]
          @destination_value = permitted_params[:destination_value].to_i

          @items = Unit.units_by_stock_id(@source_value).select(:long_name, :id).to_a

          flash[:alert] = t('errors.messages.units_not_found') if @items.blank?

          format.turbo_stream
        end
      end

      protected

      def permitted_params
        params.permit(:source_value, :destination_id, :destination_name, :destination_value)
      end
    end
  end
end
