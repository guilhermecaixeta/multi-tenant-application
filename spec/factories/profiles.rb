# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name do
      last_name = Faker::Name.last_name

      last_name = Faker::Name.last_name while last_name.size <= 3

      last_name
    end
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    user factory: %i[user]

    trait :without_user do
      user { nil }
    end

    factory :profile_without_user, traits: [:without_user]
  end
end
