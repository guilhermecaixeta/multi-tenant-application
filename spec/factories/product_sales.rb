# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :product_sale do
    product_sale_items { build_list(:product_sale_item, 1, product_sale: nil) }

    trait :for_attributes do
      expenses { nil }
      sale do
        attributes_for(:sale_attributes,
                       saleable: nil)
      end

      product_sale_items { nil }
      product_sale_items_attributes do
        {
          "#{Process.clock_gettime(Process::CLOCK_REALTIME,
                                   :microsecond)}": attributes_for(:product_sale_item_attributes)
        }
      end
    end

    factory :product_sale_attributes, traits: [:for_attributes]
  end
end
