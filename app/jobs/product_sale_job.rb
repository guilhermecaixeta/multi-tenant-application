# frozen_string_literal: true
# typed: true

# Product Sale Job
class ProductSaleJob < TenantJob
  extend T::Sig

  queue_as :default

  sig { params(tenant_name: String, product_sale_id: Integer).void }
  def perform(tenant_name, product_sale_id)
    use_tenant(tenant_name)
    product_sale = ProductSale
                   .includes(:product_sale_items)
                   .eager_load(:product_sale_items)
                   .find product_sale_id

    product_sale.calculate_expenses
  end
end
