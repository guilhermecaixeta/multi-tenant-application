# frozen_string_literal: true
# typed: true

# Catalog Callback
class CatalogCallbacks
  extend T::Sig

  sig { params(record: Catalog).void }
  def before_validation(record)
    return if T.must(T.must(record.price).price_cents).positive?

    T.must(record.price).price_cents = T.must(T.must(record.product).suggested_price).price_cents
  end
end
