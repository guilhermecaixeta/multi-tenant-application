# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Catalog do
  describe 'Validations' do
    subject { build(:catalog) }

    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid when name is missing' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when total items per catalog is missing' do
      subject.product.total_items = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:'catalogable.total_items'].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when unit weight is missing' do
      subject.product.measure = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:catalogable].first).to eq I18n.t('errors.messages.invalid')
    end

    it 'is not valid when items is empty' do
      subject.items = []
      expect(subject).not_to be_valid
    end

    it 'is not valid when name is too short' do
      subject.name = 'C'
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_short', count: 2)
    end

    it 'is not valid when name is too long' do
      subject.name = (0..256).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_long', count: 255)
    end

    it 'is not valid when items per catalog is too small' do
      subject.product.total_items = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:'catalogable.total_items'].first).to eq I18n.t(
        'errors.messages.greater_than_or_equal_to', count: 1
      )
    end

    it 'is not valid when not catalog category is informed' do
      subject.catalog_category_ids = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:catalog_category_ids].first).to eq I18n.t('errors.messages.blank')
    end
  end

  describe 'Callbacks' do
    subject { build(:catalog) }

    it 'is valid when price is updated when nil' do
      subject.price.price_cents = 0

      subject.product.suggested_price.price_cents = 500

      subject.save!

      expect(subject.price.price_cents).to be(500)
    end

    it 'is valid when price is not nil' do
      subject.price.price_cents = 500

      subject.product.suggested_price.price_cents = 700

      subject.save!

      expect(subject.price.price_cents).to be(500)
      expect(subject.product.suggested_price.price_cents).to be(700)
    end
  end

  describe 'Associations' do
    it 'is valid when has many to association with items' do
      expect(subject).to have_many(:items)
    end

    it 'is valid when has many to association with prices' do
      expect(subject).to have_many(:prices)
    end

    it 'is valid when has one association with price' do
      expect(subject).to have_one(:price)
    end
  end
end
