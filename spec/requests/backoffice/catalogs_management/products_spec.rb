# rubocop:disable Rspec/ExampleLength
# frozen_string_literal: true

RSpec.describe 'Backoffice::CatalogsManagement::Products' do
  include_context 'users',
                  'Backoffice::CatalogsManagement::Products',
                  ['Backoffice::CatalogsManagement::Products::CalculatePrices',
                   'Backoffice::CatalogsManagement::Products::RecalculatePrices',
                   'Backoffice::CatalogsManagement::Products::CalculateProfitPrice']

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_catalogs_management_products_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_catalogs_management_products_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_catalogs_management_product_path

      expect(response).to render_template(:new)

      catalog_attributes = attributes_for(:catalog_for_attributes,
                                          items_list_size: 0,
                                          catalogable: nil)

      post backoffice_catalogs_management_products_path, params: { catalog: catalog_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_catalogs_management_products_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      catalog_attributes = attributes_for(:catalog_for_attributes)

      catalog_attributes[:items_attributes] = nil
      catalog_attributes[:name] = nil

      post backoffice_catalogs_management_products_path, params: { catalog: catalog_attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      get new_backoffice_catalogs_management_product_path

      catalog_attributes = attributes_for(:catalog_for_attributes)

      post backoffice_catalogs_management_products_path, params: { catalog: catalog_attributes }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'PUT /edit' do
    let(:catalog) { create(:catalog) }

    it 'returns http success' do
      sign_in admin

      get edit_backoffice_catalogs_management_product_path(catalog)

      expect(response).to render_template(:edit)

      put backoffice_catalogs_management_product_path(catalog),
          params: { catalog: { name: 'Farinha de trigo' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_catalogs_management_products_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      put backoffice_catalogs_management_product_path(catalog), params: { catalog: { name: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      get new_backoffice_catalogs_management_product_path

      catalog_attributes = attributes_for(:product_for_attribute)

      post backoffice_catalogs_management_products_path, params: { catalog: catalog_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      sign_in admin

      catalog = create(:catalog)

      get backoffice_catalogs_management_products_path

      expect(response).to have_http_status(:success)

      delete backoffice_catalogs_management_product_path(catalog)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_catalogs_management_products_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      create(:product_sale)

      catalog = Catalog.first!

      delete backoffice_catalogs_management_product_path(catalog)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      catalog = create(:catalog)

      delete backoffice_catalogs_management_product_path(catalog)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /recalculate_prices' do
    # TODO: investigate failing tests when running all
    it 'returns http success' do
      sign_in admin

      catalog = create(:catalog)

      post recalculate_prices_backoffice_catalogs_management_product_path(catalog)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'returns http not found' do
      sign_in admin

      get backoffice_catalogs_management_products_path

      expect(response).to have_http_status(:success)

      post recalculate_prices_backoffice_catalogs_management_product_path(1)

      expect(response).to have_http_status(:not_found)
    end

    it 'returns http forbidden' do
      sign_in operator

      catalog = create(:catalog)

      post recalculate_prices_backoffice_catalogs_management_product_path(catalog)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /calculate_prices' do
    let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }

    it 'returns http success' do
      sign_in admin

      stock = singleton(:stock)

      body = {
        product: {
          'profit_rate' => 65,
          'total_items' => 5,
          'items' => [
            {
              'stock_id' => stock.id,
              'measure' => {
                'quantity' => 800,
                'unit_id' => stock.measure.unit_id
              }
            }
          ]
        }
      }

      post(calculate_prices_backoffice_catalogs_management_products_path, params: body.to_json, headers:)

      expect(response.content_type).to start_with('application/json')
      expect(response).to have_http_status(:success)
    end

    it 'returns http not found' do
      sign_in admin

      stock = singleton(:stock)

      body = {
        product: {
          'profit_rate' => 65,
          'total_items' => 5,
          'items' => [
            {
              'stock_id' => stock.id,
              'measure' => {
                'quantity' => 800,
                'unit_id' => stock.measure.unit_id
              }
            },
            {
              'stock_id' => 99,
              'measure' => {
                'quantity' => 800,
                'unit_id' => 1
              }
            }
          ]
        }
      }

      post(calculate_prices_backoffice_catalogs_management_products_path, params: body.to_json, headers:)

      expect(response).to have_http_status(:not_found)
    end

    it 'returns http forbidden' do
      body = {
        product: {
          'profit_rate' => 65.0,
          'total_items' => 5,
          'items' => [
            {
              'stock_id' => 1,
              'measure' => {
                'quantity' => 800,
                'unit_id' => 1
              }
            }
          ]
        }
      }

      sign_in operator

      post(calculate_prices_backoffice_catalogs_management_products_path, params: body.to_json, headers:)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /calculate_suggested_price/(:profit_rate)' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    # TODO: investigate failing tests when running all
    it 'returns http success' do
      catalog = create(:catalog)

      sign_in admin

      get(calculate_profit_price_backoffice_catalogs_management_product_path(id: catalog.id, profit_rate: 65.0),
          headers:)

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'returns http not found' do
      sign_in admin

      get(calculate_profit_price_backoffice_catalogs_management_product_path(id: 1, profit_rate: 65.0),
          headers:)

      expect(response).to have_http_status(:not_found)
    end

    it 'returns http forbidden' do
      catalog = singleton :catalog

      sign_in operator

      get(calculate_profit_price_backoffice_catalogs_management_product_path(id: catalog.id, profit_rate: 65.0),
          headers:)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
# rubocop:enable Rspec/ExampleLength
