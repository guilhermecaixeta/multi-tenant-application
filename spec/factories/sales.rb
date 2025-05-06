# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :sale do
    saleable factory: %i[product_sale], strategy: :singleton
    association :expenses,
                factory: :price,
                strategy: :build,
                category: Price.categories[:other]

    transient do
      price_cents { nil }
    end

    after :build do |sale, eval|
      sale.expenses.price_cents = eval.price_cents if eval.price_cents.present?
    end

    trait :for_attributes do
      expenses { nil }
      saleable_id { nil }
      saleable_type { ProductSale.name }
      expenses_attributes { attributes_for(:price, category: Price.categories[:other]) }
    end

    factory :sale_attributes, traits: [:for_attributes]
  end
end
