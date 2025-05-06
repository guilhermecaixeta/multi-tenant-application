# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    factory :gram do
      quantity { 1 }
      long_name { 'Gram' }
      short_name { 'g' }
      is_default { true }
      unit_type { Unit.unit_types[:weight] }
    end

    factory :kilo do
      quantity { 1000 }
      long_name { 'Kilo' }
      short_name { 'Kg' }
      is_default { false }
      unit_type { Unit.unit_types[:weight] }

      before(:build, :create) do
        unit_singleton :gram
      end
    end
  end
end
