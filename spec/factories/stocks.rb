# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :stock do
    quantity_available { nil }
    name { Faker::Food.ingredient }
    measure { association(:measure_for_kilo, strategy: :build) }

    transient do
      measure_quantity { nil }
      entry_price_cents { 400 }
      entry_measure_quantity { 1_000.0 }
      entry_measure_quantity_list { 1 }
    end

    after :build do |stock, eval|
      stock.measure.quantity = eval.measure_quantity if eval.measure_quantity.present?
    end

    after :create do |stock, eval|
      if eval.entry_measure_quantity_list > 0
        create_list :entry,
                    eval.entry_measure_quantity_list,
                    stock: stock,
                    total_items: eval.entry_measure_quantity,
                    price_cents: eval.entry_price_cents
      end
    end

    trait :nested_attributes do
      measure { nil }
      measure_attributes { attributes_for(:measure_for_attribute_kilo) }
    end

    factory :stock_attribute, traits: [:nested_attributes]
  end
end
