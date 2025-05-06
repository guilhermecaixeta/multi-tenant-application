# typed: true

# frozen_string_literal: true

# Policy
class StockPolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :name,
     :brand,
     :minimum_stock_level,
     :maximum_stock_level,
     { measure_attributes: MeasurePolicy.new(user, record).permitted_attributes }]
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      Stock
        .includes(:quantity_available)
        .joins(:quantity_available)
        .select('stocks.id',
                'stocks.name',
                'COALESCE(((SELECT 1 FROM entries pe WHERE pe.stock_id = stocks.id LIMIT 1) = 0), true) as destroyable')
        .order(:name)
    end
  end
end
