# frozen_string_literal: true

FactoryBot.define do
  factory :measure do
    unit factory: :gram,
         strategy: :unit_singleton
    quantity { Faker::Number.between(from: 100, to: 250) }

    trait :kilo do
      unit factory: :kilo, strategy: :unit_singleton
      quantity { Faker::Number.between(from: 1_000.0, to: 2_000.0) }
    end

    trait :for_attribute do
      unit { nil }
      unit_id { unit_singleton(:gram).id }

      quantity { nil }
      quantity_converted { Faker::Number.between(from: 100, to: 250) }
    end

    trait :for_attribute_kilo do
      unit { nil }
      unit_id { unit_singleton(:kilo).id }
      quantity_converted { Faker::Number.between(from: 1, to: 10) }
    end

    trait :for_stock do
      measurable factory: %i[stock]
    end

    trait :for_item do
      measurable factory: %i[item]
    end

    factory :measure_for_attribute_kilo, traits: [:for_attribute_kilo]
    factory :measure_for_kilo, traits: [:kilo]

    factory :measure_for_attribute, traits: [:for_attribute]
    factory :measure_for_stock, traits: [:for_stock]
    factory :measure_for_item, traits: [:for_item]
  end
end
