# frozen_string_literal: true
# typed: false

require 'rails_helper'

RSpec.describe ProductSaleItem do
  subject do
    build(:product_sale_item)
  end

  describe 'Validation' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when product id is missing' do
      subject.product = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:product].first).to eq I18n.t('errors.messages.required')
    end

    it 'is not valid when percentage profit is missing' do
      subject.profit_rate = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:profit_rate].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when total items is zero' do
      subject.total_items = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:total_items].first).to eq I18n.t('errors.messages.greater_than_or_equal_to', count: 1)
    end
  end

  describe 'Association' do
    it 'is valid when has one to association with price' do
      expect(subject).to have_one(:price)
    end

    it 'is valid when belong to product' do
      expect(subject).to belong_to(:product)
    end

    it 'is valid when belong to product sale' do
      expect(subject).to belong_to(:product_sale)
    end

    it 'is valid when has many to association with prices' do
      expect(subject).to have_many(:prices)
    end
  end

  describe 'Callbacks' do
    it 'enqueue job when created' do
      ActiveJob::Base.queue_adapter = :test

      subject.save!

      expect do
        ProductAfterSalesJob.perform_later(Apartment::Tenant.current, subject.id, (T.must(subject.total_items) * -1))
      end.to have_enqueued_job.with(Apartment::Tenant.current, subject.id, (T.must(subject.total_items) * -1))
    end

    it 'enqueue job when update' do
      ActiveJob::Base.queue_adapter = :test

      subject.save!

      subject.total_items = 2
      subject.save!

      expect do
        ProductAfterSalesJob.perform_later(Apartment::Tenant.current, subject.id, -2)
      end.to have_enqueued_job.with(Apartment::Tenant.current, subject.id, -2)
    end
  end
end
