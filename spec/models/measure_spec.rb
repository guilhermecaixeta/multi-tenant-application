# frozen_string_literal: true
# typed: true

require 'rails_helper'

# Unit test model
RSpec.describe Measure do
  subject do
    build(:measure_for_stock,
          unit: unit,
          unit_id: unit.id)
  end

  let(:unit) do
    FactoryBot.unit_singleton(:kilo)
  end

  describe 'Validations' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is valid when quantity is set correctly' do
      subject.quantity_converted = 3.5
      expect(subject.quantity.to_f).to be(3500.0)
      expect(subject.quantity_converted).to be(3.5)
    end

    it 'is not valid when quantity is too small' do
      skip 'TODO: update this rule'
      subject.quantity = -1
      expect(subject).not_to be_valid
      expect(subject.errors[:quantity].first).to eq I18n.t(
        'errors.messages.greater_than_or_equal_to', count: 1
      )
    end

    it 'is valid when base unit is same as unit after save' do
      subject.save!
      expect(subject.base_unit).to eq(unit.short_name)
    end
  end
end
