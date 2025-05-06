# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :catalog do
    name { Faker::Food.dish }
    catalog_category_ids { create_list(:catalog_category, 1).map(&:id) }
    association :catalogable,
                factory: :product,
                strategy: :build,
                catalog: nil
    association :price,
                strategy: :build
    transient do
      items_list_size { 1 }
    end

    after :build do |catalog, eval|
      if eval.items_list_size > 0
        catalog.items = build_list :item,
                                   eval.items_list_size,
                                   catalog: nil
      end
    end

    trait :for_product_attributes do
      catalogable_id { nil }
      catalogable_type { Product.name }
      catalogable_attributes { attributes_for(:product_for_attribute) }
      price { nil }
      price_attributes { attributes_for(:price) }

      items { nil }
      items_attributes do
        {
          "#{Process.clock_gettime(Process::CLOCK_REALTIME,
                                   :microsecond)}": attributes_for(:item_attribute)
        }
      end
    end

    factory :catalog_for_attributes, traits: [:for_product_attributes]
  end
end
