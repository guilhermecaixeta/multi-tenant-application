# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Unit do
  describe 'Validations' do
    subject { build(:gram) }

    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when long_name is missing' do
      subject.long_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:long_name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when short_name is missing' do
      subject.short_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:short_name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when short_name is too long' do
      subject.short_name = 'aaaaa'
      expect(subject).not_to be_valid
      expect(subject.errors[:short_name].first).to eq I18n.t('errors.messages.too_long', count: 3)
    end
  end
end
