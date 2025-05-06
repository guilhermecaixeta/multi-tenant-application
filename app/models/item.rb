# frozen_string_literal: true
# typed: true

# Model Class
class Item < ApplicationRecord
  belongs_to :stock
  belongs_to :catalog
  belongs_to :category

  has_many :entries,
           through: :stock

  has_one :measure,
          as: :measurable,
          class_name: 'Measure',
          dependent: :destroy

  validates :measure,
            presence: true

  validates_associated :measure

  accepts_nested_attributes_for :measure,
                                allow_destroy: true

  def measure_by_unit
    @measure_by_unit ||= T.must(measure).quantity / T.must(T.must(T.must(catalog).product).total_items)
    @measure_by_unit
  end
end
