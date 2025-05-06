# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :user do
    transient { custom_permissions_roles { [] } }
    transient { role_name { 'Administrator' } }

    email { Faker::Internet.email }
    confirmed_at { 1.hour.ago }
    confirmation_sent_at { 2.hours.ago }
    password do
      Faker::Internet.password(min_length: 20, max_length: 128, mix_case: true,
                               special_characters: true)
    end
    password_confirmation { password }
    force_password_change { false }

    association :profile,
                factory: :profile_without_user,
                strategy: :build
    association :access_control,
                strategy: :build

    user_roles do
      if custom_permissions_roles&.any?
        build_list :user_role,
                   1,
                   role_name:,
                   custom_permissions: custom_permissions_roles
      else
        Array.new(0)
      end
    end

    trait :for_attributes do
      profile { nil }
      profile_attributes { attributes_for(:profile_without_user) }
    end

    factory :user_for_attribute,
            traits: [:for_attributes]

    factory :user_organization do
      organization_users { build_list(:organization_user, 1) }
      organizations { organization_users.map(&:organization) }
    end
  end
end
