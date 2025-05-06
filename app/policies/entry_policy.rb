# frozen_string_literal: true
# typed: true

# Policy
class EntryPolicy < ApplicationPolicy
  def permitted_attributes
    [:id,
     :total_items,
     :validity,
     :stock_id,
     { price_attributes: PricePolicy.new(user, record).permitted_attributes }]
  end

  # Scope
  class Scope < ApplicationPolicy::Scope
    def resolve
      Entry.joins(:stock)
           .preload(:price, :quantity_available)
           .select('entries.id',
                   'entries.total_items',
                   'entries.validity',
                   'stocks.name')
           .recent
    end
  end
end
