# frozen_string_literal: true
# typed: true

# Support Class Unit
class Unit < ApplicationRecord
  enum :unit_type, { volume: 0, weight: 1, decimal: 2 }

  scope :default_weight,
        -> { where(unit_type: Unit.unit_types[:weight], is_default: true).first }
  scope :default_volume,
        -> { where(unit_type: Unit.unit_types[:weight], is_default: true).first }
  scope :units_by_stock_id,
        lambda { |stock_id|
          base_unit_type_sql = Stock
                               .joins(measure: :unit)
                               .where(id: stock_id)
                               .select('units.unit_type')
                               .limit(1)

          where(unit_type: base_unit_type_sql)
        }
end
