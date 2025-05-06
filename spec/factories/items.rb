# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :item do
    association :measure,
                strategy: :build
    association :catalog,
                strategy: :build,
                items_list_size: 0
    stock factory: %i[stock], strategy: :singleton
    category factory: %i[category], strategy: :singleton

    transient do
      measure_quantity { nil }
    end

    after :build do |item, eval|
      item.measure.quantity = eval.measure_quantity if eval.measure_quantity.present?
    end

    trait :nested_attributes do
      stock { nil }
      measure { nil }
      catalog { nil }
      category { nil }

      measure_attributes { attributes_for(:measure_for_attribute) }
      category_id { singleton(:category).id }
      stock_id { singleton(:stock).id }
    end

    factory :item_attribute, traits: [:nested_attributes]
  end
end
