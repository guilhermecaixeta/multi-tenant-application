# frozen_string_literal: true

module SaleableConcern
  extend ActiveSupport::Concern

  included do
    has_one :sale, as: :saleable, touch: true
  end
end
