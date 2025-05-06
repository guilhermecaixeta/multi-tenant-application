# frozen_string_literal: true
# typed: true

# Policy
class CatalogPolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :name,
     :show,
     :profit_rate,
     :picture,
     :description,
     :catalogable_id,
     :catalogable_type,
     { catalog_category_ids: [],
       items_attributes: ItemPolicy.new(user, record).permitted_attributes,
       price_attributes: PricePolicy.new(user, record).permitted_attributes,
       catalogable_attributes: ProductPolicy.new(user, record).permitted_attributes }]
  end
end
