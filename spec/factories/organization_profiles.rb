# frozen_string_literal: true

FactoryBot.define do
  factory :organization_profile do
    slogan { Faker::Lorem.sentence(word_count: 10) }
    about { ActionText::RichText.create(body: Faker::Lorem.sentence(word_count: 40)) }
    organization factory: :organization,
                 strategy: :singleton

    trait :for_attributes do
      organization_id { singleton(:organization).id }
    end

    factory :organization_profile_attributes, traits: [:for_attributes]
  end
end
