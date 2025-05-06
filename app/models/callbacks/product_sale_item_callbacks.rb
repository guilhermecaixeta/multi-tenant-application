# frozen_string_literal: true
# typed: true

# Callback class for product sale item
class ProductSaleItemCallbacks
  extend T::Sig

  sig { params(model: ProductSaleItem).void }
  def after_create(model)
    ProductAfterSalesJob.perform_later(Apartment::Tenant.current,
                                       T.must(model.product_id),
                                       (T.must(model.total_items) * -1))
  end

  sig { params(model: ProductSaleItem).void }
  def after_update(model)
    return if model.total_items == model.total_items_was

    total_items_diff = T.must(model.total_items) - T.must(model.total_items_was)

    return if total_items_diff.zero?

    ProductAfterSalesJob.perform_later(Apartment::Tenant.current,
                                       T.must(model.product_id),
                                       total_items_diff)
  end

  sig { params(model: ProductSaleItem).void }
  def before_destroy(model)
    ProductAfterSalesJob.perform_later(Apartment::Tenant.current,
                                       T.must(model.product_id),
                                       T.must(model.total_items))
  end
end
