# frozen_string_literal: true
# typed: true

FactoryBot.define do
  factory :organization_user do
    organization { singleton(:organization) }
  end
end
