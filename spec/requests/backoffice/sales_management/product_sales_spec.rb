# frozen_string_literal: true

RSpec.describe 'Backoffice::SalesManagement::ProductSales' do
  include_context 'users',
                  'Backoffice::SalesManagement::ProductSales'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_sales_management_product_sales_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'returns http unauthorized' do
      get backoffice_sales_management_product_sales_path

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get backoffice_sales_management_product_sales_path

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /create' do
    let!(:product_sale_attributes) { attributes_for(:product_sale_attributes) }

    it 'returns http success' do
      sign_in admin

      get new_backoffice_sales_management_product_sale_path

      expect(response).to render_template(:new)
      expect(response).to have_http_status(:success)

      post backoffice_sales_management_product_sales_path,
           params: { product_sale: product_sale_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_sales_management_product_sales_path)
    end

    it 'returns http unauthorized' do
      post backoffice_sales_management_product_sales_path,
           params: { product_sale: product_sale_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      post backoffice_sales_management_product_sales_path,
           params: { product_sale: product_sale_attributes }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      product_sale_attributes = attributes_for(:product_sale_attributes)

      product_sale_attributes[:product_sale_items_attributes] = nil

      post backoffice_sales_management_product_sales_path,
           params: { product_sale: product_sale_attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT/PATCH /edit' do
    let!(:sale) { create(:sale) }

    it 'returns http success' do
      sign_in admin

      get edit_backoffice_sales_management_product_sale_path(sale.saleable)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)

      put backoffice_sales_management_product_sale_path(sale.saleable),
          params: { product_sale: { sale: { profit_rate: 10 } } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_sales_management_product_sales_path)
    end

    it 'returns http unauthorized' do
      put backoffice_sales_management_product_sale_path(sale.saleable),
          params: { product_sale: { sale: { profit_rate: 10 } } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      put backoffice_sales_management_product_sale_path(sale.saleable),
          params: { product_sale: { profit_rate: 10 } }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      put backoffice_sales_management_product_sale_path(sale.saleable), params: { product_sale: {
        product_sale_items_attributes: [{
          total_items: -1
        }]
      } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /destroy' do
    let!(:sale) do
      sale = build(:sale)
      sale.save
      sale
    end

    it 'returns http success' do
      sign_in admin

      get backoffice_sales_management_product_sales_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      delete backoffice_sales_management_product_sale_path(sale.saleable)

      expect(response).to have_http_status(:redirect)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'returns http unauthorized' do
      delete backoffice_sales_management_product_sale_path(sale.saleable)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      delete backoffice_sales_management_product_sale_path(sale.saleable)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
