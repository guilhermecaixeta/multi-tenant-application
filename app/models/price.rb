# frozen_string_literal: true
# typed: true

# Support Class Price
class Price < ApplicationRecord
  extend T::Sig

  SHOULD_VALIDATE = %i[price unit_cost suggested].freeze

  enum :category, %w[price
                     base
                     unit_cost
                     total
                     suggested
                     expenses
                     unpredictable
                     eletricity
                     cooking_gas
                     marketing
                     other].index_by(&:to_sym)

  monetize :price_cents,
           as: 'price'

  validates :price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.01 },
            if: proc { |r| SHOULD_VALIDATE.one? r.category }

  belongs_to :priceable,
             polymorphic: true
end
