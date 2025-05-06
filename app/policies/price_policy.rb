# frozen_string_literal: true

class PricePolicy < ApplicationPolicy
  def permitted_attributes
    %i[id
       category
       price
       _destroy]
  end
end
