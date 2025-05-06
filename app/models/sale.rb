# rubocop:disable Rails/InverseOf
# frozen_string_literal: true
# typed: true

# Model class
class Sale < ApplicationRecord
  delegated_type :saleable,
                 types: [ProductSale.name],
                 dependent: :destroy,
                 autosave: true

  delegate :total_expenses_cents,
           :revenue_cents,
           :loss_cents,
           :product_names,
           to: :saleable

  has_one :expenses,
          -> { where(category: Price.categories[:other]) },
          as: :priceable,
          class_name: 'Price',
          dependent: :destroy

  accepts_nested_attributes_for :expenses,
                                allow_destroy: true

  monetize :total_expenses_cents
  monetize :revenue_cents
  monetize :profit_cents
  monetize :loss_cents

  validates :expenses,
            presence: true

  validates_associated :expenses

  def profit_cents
    revenue_cents - (loss_cents + total_expenses_cents)
  end
end
# rubocop:enable Rails/InverseOf
