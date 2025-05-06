# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    domain { name.parameterize }
    email { "email@#{domain}.com" }
    government_number { Faker::Company.brazilian_company_number }
    access_control { build(:access_control) }
    organization_profile { build(:organization_profile, organization: nil) }

    trait :for_attributes do
      access_control { nil }
      organization_profile { nil }

      access_control_attributes { attributes_for(:access_control) }
      organization_profile_attributes do
        attributes_for(:organization_profile, organization: nil, about: Faker::Lorem.sentence(word_count: 40))
      end
    end

    factory :organization_attributes, traits: [:for_attributes]
  end
end
