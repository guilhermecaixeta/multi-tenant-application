# frozen_string_literal: true
# typed: true

# Class Measure
class Measure < ApplicationRecord
  enum :kind, %w[total available].index_by(&:to_sym)

  before_validation MeasureCallbacks.new
  after_validation MeasureCallbacks.new,
                   on: %i[create update]

  belongs_to :unit
  belongs_to :measurable,
             polymorphic: true

  validates :quantity,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            if: proc { |r| r.kind == Measure.kinds[:total] }

  def quantity_converted=(str)
    @quantity_converted = 0

    return if unit_id.nil?

    @quantity_converted = str.to_f

    if @quantity_converted.nil?
      errors.add(:quantity, :blank, message: I18n.t('errors.messages.blank'))
      return
    end

    @current_unit = Unit.find(unit_id) if @current_unit.nil?

    self.quantity = @quantity_converted

    self.quantity = @quantity_converted * @current_unit.quantity unless @current_unit.is_default
  end

  def quantity_converted
    return 0 if quantity.nil?

    @current_unit = Unit.find(unit_id) if @current_unit.nil?

    @quantity_converted = quantity

    @quantity_converted = quantity / @current_unit.quantity unless @current_unit.is_default

    @quantity_converted.round(2).to_f
  end

  def to_s
    "#{quantity_converted} #{base_unit}"
  end
end
