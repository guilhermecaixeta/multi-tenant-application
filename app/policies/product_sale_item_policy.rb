# frozen_string_literal: true

class ProductSaleItemPolicy < ApplicationPolicy
  def permitted_attributes
    if record == Backoffice::SalesManagement::ProductSaleItemsController.controller_path
      [:id,
       :index,
       :category,
       :product_id,
       :total_items,
       :profit_rate,
       :use_default_price,
       :_destroy,
       { price_attributes: PricePolicy.new(user, record).permitted_attributes }]
    else
      [:id,
       :category,
       :product_id,
       :total_items,
       :profit_rate,
       :use_default_price,
       :_destroy,
       { price_attributes: PricePolicy.new(user, record).permitted_attributes }]
    end
  end
end
