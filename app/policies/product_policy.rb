# frozen_string_literal: true
# typed: true

# Policy
class ProductPolicy < ApplicationPolicy
  def permitted_attributes
    if record.action_name == 'calculate_prices'
      calculate_prices_params
    else
      product_params
    end
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      Product.load_all
    end
  end

  private

  def product_params
    [:id,
     :total_items,
     { measure_attributes: MeasurePolicy.new(user, record).permitted_attributes,
       cost_price_attributes: PricePolicy.new(user, record).permitted_attributes,
       suggested_price_attributes: PricePolicy.new(user, record).permitted_attributes }]
  end

  def calculate_prices_params
    [:profit_rate,
     :total_items,
     { items: [:stock_id, { measure: %i[quantity unit_id] }] }]
  end
end
