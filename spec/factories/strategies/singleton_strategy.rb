# frozen_string_literal: true

class SingletonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    klass = evaluation.object.class.name.constantize
    return klass.first! if klass.exists?

    evaluation.object.tap do |instance|
      evaluation.notify(:after_build, instance)
      evaluation.notify(:before_create, instance)
      evaluation.create(instance)
      evaluation.notify(:after_create, instance)
    end
  end

  def to_sym
    :singleton
  end
end
