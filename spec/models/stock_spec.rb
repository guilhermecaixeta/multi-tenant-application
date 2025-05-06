# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock do
  subject do
    build(:stock)
  end

  describe 'Validations' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when quantity is missing' do
      subject.measure = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:measure].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when name is missing' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when name is too short' do
      subject.name = 'we'
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is invalid when stock has entries and destroy is call' do
      stock = create(:stock)

      stock.valid?(:delete)

      expect(stock.errors[:base].first).to eq I18n.t('errors.messages.can_not_be_deleted',
                                                     attribute: described_class.model_name.human,
                                                     reason: I18n.t('errors.messages.reasons.has_entries'))
    end
  end

  describe 'Callbacks' do
    it 'is valid when measure unit change and quantity available reflect the change' do
      unit = FactoryBot.unit_singleton :unit,
                                       quantity: 1,
                                       long_name: 'Unidade',
                                       short_name: 'Un',
                                       is_default: true,
                                       unit_type: Unit.unit_types[:decimal]
      subject.save!

      subject.measure.unit = unit
      subject.save!
      subject.reload

      expect(subject.quantity_available.unit).to eq(unit)
    end

    it 'is valid when measure unit change and entries quantity available reflect the change' do
      unit = FactoryBot.unit_singleton :unit,
                                       quantity: 1,
                                       long_name: 'Unidade',
                                       short_name: 'Un',
                                       is_default: true,
                                       unit_type: Unit.unit_types[:decimal]

      stock = create(:stock)

      stock.measure.unit = unit
      stock.save!

      stock.reload

      stock.entries.each do |entry|
        expect(entry.quantity_available.unit).to eq(unit)
      end
    end
  end

  describe 'Associations' do
    it 'is valid when has have one to association with quantity by unit' do
      expect(subject).to have_one(:measure)
    end
  end

  describe 'Concerns' do
    describe 'Rebalance Stock' do
      let!(:stock) do
        singleton(:stock,
                  measure_quantity: 1_000.0,
                  entry_measure_quantity: 2,
                  entry_measure_quantity_list: 2)
      end

      let(:product_cost_price) do
        build(:price,
              price: 1.20,
              category: :unit_cost)
      end

      let(:product) do
        build(:product,
              total_items: 4,
              measure_quantity: 200,
              cost_price: product_cost_price)
      end

      let(:item) do
        build(:item,
              catalog: nil,
              measure_quantity: 800)
      end

      let(:catalog_price) do
        build(:price,
              price: 0.80)
      end

      let(:catalog) do
        singleton(:catalog,
                  items: [item],
                  items_list_size: 0,
                  price: catalog_price,
                  catalogable: product)
      end

      describe 'Increase balance' do
        let(:decrease_stock_balance) do
          stock.reload
          stock.quantity_available.quantity -= 400
          stock.save!
        end

        it 'is valid when stock is increased' do
          decrease_stock_balance

          described_class.rebalance_from_product_id(catalog.id, 2)

          stock_quantity = Measure.where(measurable_type: described_class.name,
                                         measurable_id: stock.id,
                                         kind: Measure.kinds[:available]).pick :quantity

          expect(stock_quantity.to_f).to be(4000.0)
        end

        it 'is invalid when total items is greater then balance available' do
          expect do
            described_class.rebalance_from_product_id(catalog.id, 100)
          end.to raise_error(DomainErrors::InsufficientBalanceError)
        end
      end

      describe 'Decrease balance' do
        it 'is valid when stock is decreased' do
          described_class.rebalance_from_product_id(catalog.id, -2)

          stock_quantity = Measure.where(measurable_type: described_class.name,
                                         measurable_id: stock.id,
                                         kind: Measure.kinds[:available]).pick :quantity

          expect(stock_quantity.to_f).to be(3600.0)
        end

        it 'is invalid when total items is greater then balance available' do
          expect do
            described_class.rebalance_from_product_id(catalog.id, -100)
          end.to raise_error(DomainErrors::InsufficientBalanceError)
        end
      end
    end
  end
end
