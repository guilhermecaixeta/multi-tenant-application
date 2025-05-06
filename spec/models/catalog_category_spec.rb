# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogCategory do
  subject { create(:catalog_category) }

  describe 'Validations' do
    it 'is valid when all fields required are fulfilled' do
      expect(subject).to be_valid
    end

    it 'is invalid when title is missing' do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when description i missing' do
      subject.description = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:description].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when title is too short' do
      subject.title = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:title].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is invalid when title is too long' do
      subject.title = (0..64).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:title].first).to eq I18n.t('errors.messages.too_long', count: 64)
    end

    it 'is invalid when description is too short' do
      subject.description = 'a'
      expect(subject).not_to be_valid
      expect(subject.errors[:description].first).to eq I18n.t('errors.messages.too_short', count: 5)
    end

    it 'is invalid when description is too long' do
      subject.description = (0..401).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:description].first).to eq I18n.t('errors.messages.too_long', count: 400)
    end
  end
end
