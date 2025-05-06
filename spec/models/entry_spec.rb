# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry do
  describe 'Validations' do
    subject do
      build(:entry)
    end

    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when total items is missing' do
      skip 'TODO: fix nil can\'t be coecerd to BigDecimal'

      subject.total_items = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:total_items].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when validity is missing' do
      subject.validity = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:validity].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when price is missing' do
      subject.price = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:price].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when quantity is small than 1' do
      subject.total_items = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:total_items].first).to eq I18n.t(
        'errors.messages.greater_than_or_equal_to', count: 1
      )
    end

    it 'is not valid when validity is in past' do
      subject.validity = Time.zone.today - 1.hour
      expect(subject).not_to be_valid
      # expect(subject.errors[:validity].first).to match I18n.t("errors.messages.greater_than").sub("%<count>s", "")
    end
  end

  describe 'Callbacks' do
    let!(:stock) do
      create(:stock,
             entry_measure_quantity_list: 0,
             measure_quantity: 1_000.0)
    end

    it 'has to update the stock_management after create' do
      entry = create(:entry)

      stock.reload

      expected_result = stock.measure.quantity * entry.total_items
      expect(stock.quantity_available.quantity.to_f).to eql(expected_result.to_f)
    end

    it 'has to update the stock_management after create multiple entries' do
      create(:entry, total_items: 1)
      create(:entry, total_items: 3)

      expected_result = stock.measure.quantity * 4
      stock.reload

      expect(stock.quantity_available.quantity.to_f).to eql(expected_result.to_f)
    end

    it 'has to update the stock_management after update' do
      create(:entry, total_items: 3)
      entry = create(:entry, total_items: 1)

      entry.total_items = 2
      entry.save!

      expected_result = stock.measure.quantity * 5
      stock.reload
      expect(stock.quantity_available.quantity.to_f).to eql(expected_result.to_f)
    end

    it 'has to update the stock_management after update' do
      entry = create(:entry, total_items: 1)
      entry.total_items = 2
      entry.save!

      stock.reload
      expect(stock.quantity_available.quantity).to eq(entry.quantity_available.quantity)
    end

    it 'has to update the stock_management after delete' do
      entry = build(:entry, total_items: 3)
      entry.save!

      entry.destroy

      stock.reload
      expect(stock.quantity_available.quantity).to eq(0)
    end
  end

  describe 'Associations' do
    it 'is valid when has have one to association with quantity by unit' do
      expect(subject).to have_one(:price)
    end
  end

  describe 'Concerns' do
    describe 'Product After Sales' do
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
        create(:catalog,
               items: [item],
               items_list_size: 0,
               price: catalog_price,
               catalogable: product)
      end

      describe 'Increase balance' do
        let(:setup_single_entry) do
          entry = described_class.recent.first
          entry.quantity_available.quantity -= 400
          entry.quantity_available.save!
        end

        let(:setup_multiple_entries) do
          stock.reload
          stock.quantity_available.quantity -= 2400
          stock.save!

          entry = described_class.recent.first
          entry.quantity_available.quantity = 0.0
          entry.quantity_available.save!

          entry = described_class.recent.last
          entry.quantity_available.quantity -= 400.0
          entry.quantity_available.save!
        end

        it 'is valid when entry is increased' do
          setup_single_entry

          described_class.rebalance_from_product_id(catalog.id, 2)

          updated_entry_quantity = Measure.where(measurable_type: described_class.name,
                                                 measurable_id: stock.entries.recent.first.id).pick :quantity

          expect(updated_entry_quantity.to_f).to be(2000.0)
        end

        it 'is valid when multiple entry is increased' do
          setup_multiple_entries

          described_class.rebalance_from_product_id(catalog.id, 12)

          entry_quantity_first = Measure.where(measurable_type: described_class.name,
                                               measurable_id: stock.entries.recent.first.id).pick :quantity

          entry_quantity_last = Measure.where(measurable_type: described_class.name,
                                              measurable_id: stock.entries.recent.first.id).pick :quantity

          expect(entry_quantity_first.to_f).to be(2000.0)
          expect(entry_quantity_last.to_f).to be(2000.0)
        end

        it 'is valid when entry is increased and there is multiple products' do
          create(:catalog)

          setup_multiple_entries

          described_class.rebalance_from_product_id(catalog.id, 12)

          entry_quantity_first = Measure.where(measurable_type: described_class.name,
                                               measurable_id: stock.entries.recent.first.id).pick :quantity

          entry_quantity_last = Measure.where(measurable_type: described_class.name,
                                              measurable_id: stock.entries.recent.first.id).pick :quantity

          expect(entry_quantity_first.to_f).to be(2000.0)
          expect(entry_quantity_last.to_f).to be(2000.0)
        end

        it 'is invalid when total items is greater then balance available' do
          expect do
            described_class.rebalance_from_product_id(catalog.id, 100)
          end.to raise_error(DomainErrors::InsufficientBalanceError)
        end
      end

      describe 'Decrease balance' do
        it 'is valid when entries is decreased' do
          described_class.rebalance_from_product_id(catalog.id, -2)

          entry_quantity = Measure.where(measurable_type: described_class.name,
                                         measurable_id: stock.entries.recent.first.id).pick :quantity

          expect(entry_quantity.to_f).to be(1600.0)
        end

        it 'is valid when multiple entries is decreased' do
          described_class.rebalance_from_product_id(catalog.id, -12)

          entry_quantity_first = Measure.where(measurable_type: described_class.name,
                                               measurable_id: stock.entries.recent.first.id).pick :quantity

          entry_quantity_last = Measure.where(measurable_type: described_class.name,
                                              measurable_id: stock.entries.recent.last.id).pick :quantity

          expect(entry_quantity_first.to_f).to be(0.0)
          expect(entry_quantity_last.to_f).to be(1600.0)
        end

        it 'is valid when multiple entries and multiple products is decreased' do
          create(:catalog)

          described_class.rebalance_from_product_id(catalog.id, -12)

          entry_quantity_first = Measure.where(measurable_type: described_class.name,
                                               measurable_id: stock.entries.recent.first.id).pick :quantity

          entry_quantity_last = Measure.where(measurable_type: described_class.name,
                                              measurable_id: stock.entries.recent.last.id).pick :quantity

          expect(entry_quantity_first.to_f).to be(0.0)
          expect(entry_quantity_last.to_f).to be(1600.0)
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
