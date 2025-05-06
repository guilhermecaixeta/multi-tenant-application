# frozen_string_literal: true

class SalePolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :saleable_id,
     :saleable_type,
     :profit_rate,
     { expenses_attributes: PricePolicy.new(user, record).permitted_attributes }]
  end
end
