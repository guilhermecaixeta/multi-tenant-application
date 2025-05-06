# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    title { "#{Backoffice::StockManagement::StocksController}:read" }
    scope { "#{Backoffice::StockManagement::StocksController}:read" }
  end
end
