# frozen_string_literal: true

class UnitsSingletonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    return evaluation unless evaluation.object.is_a?(Unit)

    if Unit.exists?(short_name: evaluation.object.short_name)
      Unit.where(short_name: evaluation.object.short_name).first!
    else
      evaluation.object.tap do |instance|
        evaluation.notify(:after_build, instance)
        evaluation.notify(:before_create, instance)
        evaluation.create(instance)
        evaluation.notify(:after_create, instance)
      end
    end
  end

  def to_sym
    :unit_singleton
  end
end
