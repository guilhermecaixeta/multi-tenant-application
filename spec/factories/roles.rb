# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    transient { custom_permissions { [] } }
    name { Faker::Name }
    permissions { custom_permissions.map { |p| create(:permission, title: p, scope: p) } }
  end
end
