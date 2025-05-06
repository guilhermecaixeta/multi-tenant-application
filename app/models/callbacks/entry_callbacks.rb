# rubocop:disable Rails/SkipsModelValidations
# frozen_string_literal: true
# typed: true

# Callback class for entry
class EntryCallbacks
  extend T::Sig

  sig { params(model: Entry).void }
  def before_validation(model)
    stock_measure = find_measure_by_stock_id model.stock_id

    if model.quantity_available.nil?
      model.quantity_available = Measure.new quantity: model.quantity_total,
                                             unit_id: T.must(stock_measure).unit_id
      return
    end

    update_quantity_available(model,
                              stock_measure)
  end

  sig { params(model: Entry).void }
  def after_create(model)
    stock_availability = find_measure_by_stock_id(model.stock_id)

    T.must(stock_availability).increment!(:quantity,
                                          T.must(model.quantity_available).quantity.to_i)
  end

  sig { params(model: Entry).void }
  def after_update(model)
    stock_availability = find_measure_by_stock_id(model.stock_id)

    update_measure_quantity stock_availability,
                            T.must(T.must(model.quantity_available).quantity_was),
                            T.must(model.quantity_available).quantity
  end

  sig { params(model: Entry).void }
  def after_destroy(model)
    stock_measure = find_measure_by_stock_id(model.stock_id)

    return unless (T.must(stock_measure).quantity - T.must(model.quantity_available).quantity) >= 0

    T.must(stock_measure).decrement!(:quantity,
                                     T.must(model.quantity_available).quantity.to_i)
  end

  private

  sig { params(stock_id: Integer).returns(Measure) }
  def find_measure_by_stock_id(stock_id)
    Measure.find_by! measurable_type: Stock.name,
                     measurable_id: stock_id,
                     kind: Measure.kinds[:available]
  end

  sig { params(stock_availability: Measure, previous_value: BigDecimal, current_value: BigDecimal).void }
  def update_measure_quantity(stock_availability, previous_value, current_value)
    T.must(stock_availability).quantity -= previous_value
    T.must(stock_availability).quantity += current_value
    T.must(stock_availability).save!
  end

  sig { params(model: Entry, stock_measure: Measure).void }
  def update_quantity_available(model, stock_measure)
    T.must(model.quantity_available).quantity = model.quantity_total
    T.must(model.quantity_available).unit_id = T.must(stock_measure).unit_id
  end
end
# rubocop:enable Rails/SkipsModelValidations
