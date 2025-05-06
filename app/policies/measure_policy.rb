# frozen_string_literal: true

class MeasurePolicy < ApplicationPolicy
  def permitted_attributes
    %i[id unit_id quantity_converted]
  end
end
