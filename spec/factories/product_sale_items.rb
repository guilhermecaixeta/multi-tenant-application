# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :product_sale_item do
    category { ProductSaleItem.categories[:sale] }
    total_items { Faker::Number.between(from: 1, to: 4) }
    profit_rate { Faker::Number.between(from: 5, to: 999) }
    product { singleton(:catalog).product }

    association :price,
                strategy: :build
    association :product_sale,
                strategy: :build,
                product_sale_items: []

    trait :for_attributes do
      product { nil }
      product_id { singleton(:product).id }
      price { nil }
      price_attributes { attributes_for(:price, Price.categories[:price]) }
    end

    factory :product_sale_item_attributes, traits: [:for_attributes]
  end
end
