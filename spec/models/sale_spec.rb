# frozen_string_literal: true
# typed: true

require 'rails_helper'

RSpec.describe Sale do
  describe 'Product Sale' do
    subject do
      build(:sale,
            price_cents: 11_000,
            saleable: product_sale)
    end

    let!(:stock) do
      singleton(:stock,
                measure_quantity: 1_000.0,
                entry_measure_quantity: 2,
                entry_measure_quantity_list: 2)
    end

    let!(:product_cost_price) do
      build(:price,
            price: 1.20,
            category: :unit_cost)
    end

    let!(:product) do
      build(:product,
            total_items: 4,
            measure_quantity: 200,
            cost_price: product_cost_price)
    end

    let!(:item) do
      build(:item,
            catalog: nil,
            measure_quantity: 800)
    end

    let!(:catalog_price) do
      build(:price,
            price: 0.80)
    end

    let!(:catalog) do
      singleton(:catalog,
                items: [item],
                items_list_size: 0,
                price: catalog_price,
                catalogable: product)
    end

    let!(:product_sale_item) do
      build(:product_sale_item,
            price: product_sale_price,
            total_items: 2,
            product:,
            product_sale: nil)
    end

    let!(:product_sale_price) do
      build(:price,
            price: 1.60)
    end

    let!(:product_sale) do
      build(:product_sale,
            product_sale_items: [product_sale_item])
    end

    describe 'Validation' do
      it 'is valid when has all required attributes' do
        expect(subject).to be_valid
        expect(subject.errors).to be_empty
      end

      it 'is invalid when has no balance' do
        product_sale_item_1 = build(:product_sale_item,
                                    total_items: 10,
                                    product_sale: nil)
        product_sale_item_2 = build(:product_sale_item,
                                    total_items: 20,
                                    product_sale: nil)
        product_sale_item_3 = build(:product_sale_item,
                                    total_items: 5,
                                    product_sale: nil)

        product_sale = build(:product_sale,
                             product_sale_items: [product_sale_item_1,
                                                  product_sale_item_2,
                                                  product_sale_item_3])

        expect(product_sale).not_to be_valid
        expect(product_sale.errors[:base].first).to eq I18n.t('errors.messages.stock_insuficient_quantity')
      end
    end

    describe 'Monetize' do
      it 'is valid when priceable is informed' do
        expect(subject.expenses.price.to_hash).to eq(cents: 11_000, currency_iso: 'BRL')
      end

      it 'is valid when product orders price is same as revenue is returned' do
        expect(subject.revenue.to_hash).to eq(cents: 320, currency_iso: 'BRL')
      end
    end

    describe 'Callbacks' do
      let!(:set_test_queue) { ActiveJob::Base.queue_adapter = :test }

      it 'Product Sale Job is enqueued after save' do
        product_sale.save!

        expect do
          ProductSaleJob.perform_later(product_sale.id)
        end.to have_enqueued_job.with(product_sale.id)
      end
    end

    describe 'Concerns' do
      describe 'Product Sale Expense' do
        it 'is valid when update the product expenses price after create' do
          subject.save!

          subject.product_sale.calculate_expenses

          price = Price.find_by(priceable_type: ProductSale.name,
                                priceable_id: subject.product_sale.id,
                                category: Price.categories[:expenses])

          expect(price.price_cents).to be(240)
        end
      end
    end
  end
end
