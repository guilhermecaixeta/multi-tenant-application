# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :product do
    total_items { 4 }
    association :measure,
                strategy: :build
    association :cost_price,
                factory: :price,
                strategy: :build,
                category: Price.categories[:unit_cost]
    association :suggested_price,
                factory: :price,
                strategy: :build,
                category: Price.categories[:suggested]
    association :catalog,
                strategy: :build,
                catalogable: nil,
                items_list_size: 0

    transient do
      measure_quantity { nil }
    end

    after :build do |product, eval|
      product.measure.quantity = eval.measure_quantity if eval.measure_quantity.present?
    end

    trait :for_attributes do
      measure { nil }
      measure_attributes { attributes_for(:measure_for_attribute) }

      suggested_price { nil }
      suggested_price_attributes { attributes_for(:price) }

      cost_price { nil }
      cost_price_attributes { attributes_for(:price) }
    end

    factory :product_for_attribute, traits: [:for_attributes]
  end
end
