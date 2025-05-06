# frozen_string_literal: true
# typed: true

# Callback class for stock
class StockCallbacks
  extend T::Sig

  sig { params(model: Stock).void }
  def before_create(model)
    return if model.quantity_available.present?

    model.quantity_available = Measure.new(unit: T.must(model.measure).unit,
                                           quantity: 0,
                                           kind: Measure.kinds[:available])
  end

  sig { params(model: Stock).void }
  def after_update(model)
    update_quantity_available model
    update_quantity_available_of_entries model
  end

  private

  def update_quantity_available(model)
    model.quantity_available.unit_id = model.measure.unit_id
    model.quantity_available.unit = model.measure.unit
    model.quantity_available.save!
  end

  def update_quantity_available_of_entries(model)
    measures = []
    model.entries.each do |entry|
      entry.quantity_available.unit_id = model.measure.unit_id
      entry.quantity_available.base_unit = model.measure.unit.short_name
      measures << entry.quantity_available.attributes
    end

    Measure.upsert_all measures, record_timestamps: true
  end
end
