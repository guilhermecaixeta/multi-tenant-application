# frozen_string_literal: true
# typed: true

# Callback
class MeasureCallbacks
  extend T::Sig

  sig { params(model: Measure).void }

  def before_validation(model)
    model.kind = Measure.kinds[:total] if model.kind.nil?
  end

  sig { params(model: Measure).void }

  def after_validation(model)
    if model.unit_id.nil?
      model.errors.add :unit, :blank, message: 'errors.messages.blank'
      return
    end

    return unless model.unit_id_changed?

    unit = Unit.select(:short_name).find model.unit_id
    model.base_unit = unit.short_name
  end
end
