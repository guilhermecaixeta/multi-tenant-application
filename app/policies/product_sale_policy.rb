# frozen_string_literal: true

class ProductSalePolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     { sale_attributes: SalePolicy.new(user, record).permitted_attributes,
       expenses_attributes: PricePolicy.new(user, record).permitted_attributes,
       product_sale_items_attributes: ProductSaleItemPolicy.new(user,
                                                                record).permitted_attributes }]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      ProductSale
        .eager_load(:expenses,
                    sale: [:expenses],
                    product_sale_items: [:price, { product: :catalog }])
        .references(:expenses,
                    sale: [:expenses],
                    product_sale_items: [:price, { product: :catalog }])
    end
  end
end
