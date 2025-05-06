# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::SalesManagement::ProductSaleItems' do
  include_context 'users',
                  'Backoffice::SalesManagement::ProductSaleItems'

  let(:headers) do
    { 'ACCEPT' => 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml' }
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      post(new_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
           headers: headers)

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      post(new_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
           headers: headers)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      post(new_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
           headers: headers)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      sign_in admin

      delete(destroy_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
             headers: headers)

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      delete(destroy_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
             headers: headers)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      delete(destroy_backoffice_sales_management_product_sale_item_path(index: 'catalog_items'),
             headers: headers)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
