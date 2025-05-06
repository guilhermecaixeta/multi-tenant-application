# frozen_string_literal: true
# typed: true

# Model class
class Stock < ApplicationRecord
  include RebalanceStockConcern

  before_create StockCallbacks.new
  after_update StockCallbacks.new

  has_one :measure,
          -> { where(kind: Measure.kinds[:total]) },
          as: :measurable,
          class_name: 'Measure',
          dependent: :destroy

  has_one :quantity_available,
          -> { where(kind: Measure.kinds[:available]) },
          as: :measurable,
          class_name: 'Measure',
          dependent: :destroy

  has_many :items,
           class_name: 'Item'

  has_many :entries,
           class_name: 'Entry'

  accepts_nested_attributes_for :measure,
                                allow_destroy: true

  def quantity_total
    entries.sum(&:quantity_total)
  end
end
