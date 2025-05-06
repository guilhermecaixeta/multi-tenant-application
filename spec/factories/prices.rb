# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    price { Faker::Number.between(from: 1_000, to: 999_999) }
    category { Price.categories[:price] }
  end
end
