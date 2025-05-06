# frozen_string_literal: true

class CatalogCategoryPolicy < ApplicationPolicy
  def permitted_attributes
    %i[title
       description
       default_picture]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      CatalogCategory.all.with_rich_text_description
    end

    private

    attr_reader :user, :scope
  end
end
