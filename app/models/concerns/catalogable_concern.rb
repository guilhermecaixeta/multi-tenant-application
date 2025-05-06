# frozen_string_literal: true

module CatalogableConcern
  extend ActiveSupport::Concern

  included do
    has_one :catalog, as: :catalogable, touch: true
  end
end
