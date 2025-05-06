# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessControl do
  subject { build(:access_control, has_user: true) }

  describe 'Validations' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is invalid when active from is in past' do
      subject.active_from = Time.zone.today - 1.day
      expect(subject).not_to be_valid
      expect(subject.errors[:active_from].first).to eq I18n.t('errors.messages.greater_than_or_equal_to',
                                                              count: Time.zone.today)
    end

    it 'is invalid when active until is smaller than active from' do
      subject.active_from = Time.zone.today + 1.day
      subject.active_until = Time.zone.today
      expect(subject).not_to be_valid
      expect(subject.errors[:active_until].first).to eq I18n.t('errors.messages.greater_than',
                                                               count: subject.active_from)
    end

    it 'is valid when active from is lesse than today' do
      subject.active_from = Time.zone.today - 1.day
      expect(subject).to be_active
    end

    it 'is valid when active unitl is greaater than today' do
      subject.active_until = Time.zone.today + 1.day
      expect(subject).to be_active
    end

    it 'is invalid when is in of interval' do
      subject.active_from = Time.zone.today - 1.day
      subject.active_until = Time.zone.today + 5.days
      expect(subject).to be_active
    end

    it 'is invalid when active until is in past' do
      subject.active_until = Time.zone.today - 1.day
      expect(subject).not_to be_valid
      expect(subject.errors[:active_until].first).to eq I18n.t('errors.messages.greater_than',
                                                               count: Time.zone.today.beginning_of_day)
    end

    it 'is invalid when active from is greater than today' do
      subject.active_from = Time.zone.today + 1.day
      expect(subject).not_to be_active
    end

    it 'is invalid when active until is lesser than today' do
      subject.active_until = Time.zone.today - 1.day
      expect(subject).not_to be_active
    end

    it 'is invalid if active_from is empty' do
      subject.active_from = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:active_from].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when is out of interval' do
      subject.active_from = Time.zone.today + 1.day
      subject.active_until = Time.zone.today + 5.days
      expect(subject).not_to be_active
    end
  end

  describe 'Active?' do
    it 'is true when active is true and the dates from and until are empty' do
      existing_access_control = create(:user).access_control

      expect(existing_access_control).to be_active
    end

    it 'is true when active is false and the date from is today and date until is empty' do
      access_control = build(:access_control, active_from: Time.zone.today, active_until: nil)
      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).to be_active
    end

    it 'is true when active is true and the date from is today and date until is tomorrow' do
      access_control = build(:access_control,
                             active_from: Time.zone.today,
                             active_until: Time.zone.today + 1.day)

      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).to be_active
    end

    it 'is true when active is true and the date from is nil and date until is tomorrow' do
      access_control = build(:access_control,
                             active_until: Time.zone.today + 1.day)

      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).to be_active
    end

    it 'is false when active is true and the date from is in tomorrow and date until is in future' do
      access_control = build(:access_control,
                             active: true,
                             active_from: Time.zone.today + 1.day,
                             active_until: Time.zone.today + 2.days)

      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).not_to be_active
    end

    it 'is false when active is false and the date from is today and date until is in future' do
      access_control = build(:access_control,
                             active: false,
                             active_from: Time.zone.today,
                             active_until: Time.zone.today + 2.days)

      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).not_to be_active
    end

    it 'is false when active is false and the date from is nil and date until is in future' do
      access_control = build(:access_control,
                             active: false,
                             active_until: Time.zone.today + 2.days)

      existing_access_control = create(:user, access_control:).access_control

      expect(existing_access_control).not_to be_active
    end

    it 'is false when active is true and the date from and date until is in past' do
      access_control = build(:access_control,
                             active_from: Time.zone.today - 2.days,
                             active_until: Time.zone.today - 1.day)

      user = build(:user, access_control:)

      user.save!(validate: false)

      expect(user.access_control).not_to be_active
    end
  end
end
