# frozen_string_literal: true

FactoryBot.define do
  factory :access_control do
    active { true }
    active_from { Time.zone.today.to_date }
    active_until { nil }

    transient do
      has_user { false }
      has_organization { false }
    end

    after :build do |access_control, eval|
      access_control.controlable = build(:user) if eval.has_user
      access_control.controlable = build(:organization) if eval.has_organization
    end
  end
end
