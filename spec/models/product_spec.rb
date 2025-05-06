# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  subject { build(:product) }

  let!(:stock) do
    singleton(:stock,
              measure_quantity: 1_000.0,
              entry_measure_quantity: 1,
              entry_measure_quantity_list: 1)
  end

  let(:price) do
    build(:price,
          price_cents: 1000,
          category: :unit_cost)
  end

  let(:item) do
    build(:item,
          catalog: nil,
          measure_quantity: 800)
  end

  let(:catalog) do
    build(:catalog,
          items: [item],
          items_list_size: 0,
          price:,
          catalogable: nil)
  end

  let(:product) do
    create(:product,
           total_items: 4,
           measure_quantity: 200,
           cost_price: price,
           suggested_price: price,
           catalog:)
  end

  let(:product_map) do
    {
      'profit_rate' => 50.0,
      'total_items' => 4,
      'items' => [{
        'stock_id' => stock.id,
        'measure' => {
          'quantity' => item.measure.quantity_converted,
          'unit_id' => item.measure.unit_id
        }
      }]
    }
  end

  let(:update_entries_price) do
    Price.where(priceable_type: Entry.name).find_each do |price|
      price.update_columns(price_cents: 1600) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  describe 'Validations' do
    subject do
      build(:product)
    end

    it 'is valid when all attributes exists' do
      expect(subject).to be_valid
    end

    it 'is invalid when is missing total_items' do
      subject.total_items = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:total_items].first).to eq I18n.t 'errors.messages.blank'
    end

    it 'is invalid when is missing measure' do
      subject.measure = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:measure].first).to eq I18n.t 'errors.messages.blank'
    end
  end

  describe 'Associations' do
    it 'is valid when has have one association with quantity by unit' do
      expect(subject).to have_one(:measure)
    end

    it 'is valid when has many to association with catalogs costs' do
      expect(subject).to have_many(:product_sale_items)
    end

    it 'is valid when has one association with base price' do
      expect(subject).to have_one(:cost_price)
    end

    it 'is valid when has one association with suggested price' do
      expect(subject).to have_one(:suggested_price)
    end
  end

  describe 'Concerns' do
    it 'is valid when concern return value added the profit rate' do
      price = described_class.calculate_profit(product.id, 50.0)
      expected_price = Money.new(1500)
      expect(price).to eq(expected_price.to_s)
    end

    it 'is valid when prices are recalculated' do
      update_entries_price
      product.recalculate_prices
      product.reload

      expect(product.suggested_price.price_cents).to be(320)
    end

    it 'is valid when has one association with base price' do
      expect(described_class.calculate_prices(product_map)).to eq({ cost_price: Money.new(80).to_s,
                                                                    suggested_price: Money.new(120).to_s })
    end
  end

  describe 'Scopes' do
    it 'is valid when scope return updated cost price' do
      update_entries_price
      expect(described_class.calculate_last_cost_price_cents(product.id)).to be(320)
    end

    it 'is valid when return cost prices' do
      product
      expect(described_class.calculate_cost_price.first!.price_cents).to be(80)
    end

    it 'is valid when return updated prices' do
      product
      expect(described_class.load_all.count).to be(1)
    end
  end
end
