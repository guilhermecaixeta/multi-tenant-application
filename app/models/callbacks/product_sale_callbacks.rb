# frozen_string_literal: true
# typed: true

# Product Sale Callback
class ProductSaleCallbacks
  extend T::Sig

  sig { params(model: ProductSale).void }
  def after_create(model)
    ProductSaleJob.perform_later(Apartment::Tenant.current, model.id)
  end

  sig { params(model: ProductSale).void }
  def after_update(model)
    ProductSaleJob.perform_later(Apartment::Tenant.current, model.id)
  end
end
