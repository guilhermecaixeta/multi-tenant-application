# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :entry do
    total_items { Faker::Number.between(from: 1, to: 10) }
    validity { Faker::Date.between(from: DateTime.now + 1.day, to: DateTime.now + 12.months) }
    association :price,
                strategy: :build
    stock factory: %i[stock], strategy: :singleton, entry_measure_quantity_list: 0

    transient do
      price_cents { nil }
    end

    after :build do |entry, eval|
      entry.price.price_cents = eval.price_cents if eval.price_cents.present?
    end

    trait :nested_attributes do
      price { nil }
      stock { nil }

      price_attributes { attributes_for(:price) }
      stock_id { create(:stock).id }
    end

    factory :entry_attribute, traits: [:nested_attributes]
  end
end
