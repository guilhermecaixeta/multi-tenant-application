# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def permitted_attributes
    if record == Backoffice::CatalogsManagement::ItemsController.controller_path
      %i[index scope id]
    else
      [:id,
       :stock_id,
       :category_id,
       :_destroy,
       { measure_attributes: MeasurePolicy.new(user, record).permitted_attributes }]
    end
  end
end
