# frozen_string_literal: true
# typed: true

# concern
module ProductSaleExpenseConcern
  extend ActiveSupport::Concern
  extend T::Sig

  included do
    def calculate_expenses
      price_cents = calculate_products_expenses
      if expenses.nil?
        self.expenses = Price.new(price_cents:,
                                  category: Price.categories[:expenses])
      else
        T.must(expenses).price_cents = price_cents
      end

      T.must(expenses).save!
    end

    private

    sig { returns(Integer) }
    def calculate_products_expenses
      T.must(product_sale_items)
       .filter { |po| po.category == ProductSaleItem.categories[:sale] }
       .sum do |po|
        calculate_expenses_price T.must(po.product_id), T.must(po.total_items)
      end.to_i
    end

    sig { params(product_id: Integer, total_items: Integer).returns(Integer) }
    def calculate_expenses_price(product_id, total_items)
      Price.where(priceable_type: Product.name)
           .where(priceable_id: product_id)
           .where(category: :unit_cost)
           .order(created_at: :desc)
           .limit(1)
           .pick(:price_cents) * total_items
    end
  end
end
