# frozen_string_literal: true
# typed: true

# Rebalance on Create Job
class ProductAfterSalesJob < TenantJob
  extend T::Sig

  queue_as :default

  sig { params(tenant_name: String, product_id: Integer, total_items: Integer).void }
  def perform(tenant_name, product_id, total_items)
    use_tenant(tenant_name)
    Stock.rebalance_from_product_id(product_id, total_items)
    Entry.rebalance_from_product_id(product_id, total_items)
  end
end
