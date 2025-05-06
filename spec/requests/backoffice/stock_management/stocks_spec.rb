# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::StockManagement::Stocks' do
  include_context 'users',
                  'Backoffice::StockManagement::Stocks'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_stock_management_stocks_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_stock_management_stocks_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_stock_management_stock_path

      expect(response).to render_template(:new)

      stock_attributes = attributes_for(:stock_attribute)

      post backoffice_stock_management_stocks_path, params: { stock: stock_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_stocks_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get new_backoffice_stock_management_stock_path

      expect(response).to render_template(:new)

      stock_attributes = attributes_for(:stock)

      post backoffice_stock_management_stocks_path, params: { stock: stock_attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      get new_backoffice_stock_management_stock_path
      stock_attributes = attributes_for(:stock_attribute)

      post backoffice_stock_management_stocks_path, params: { stock: stock_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'PUT /edit' do
    it 'returns http success' do
      stock = create(:stock)

      sign_in admin

      get edit_backoffice_stock_management_stock_path(stock)

      expect(response).to render_template(:edit)

      put backoffice_stock_management_stock_path(stock),
          params: { stock: { name: 'Farinha de trigo' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_stocks_path)
    end

    it 'returns http unprocessable entity' do
      stock = create(:stock)

      sign_in admin

      get edit_backoffice_stock_management_stock_path(stock)

      expect(response).to render_template(:edit)

      put backoffice_stock_management_stock_path(stock), params: { stock: { name: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      get new_backoffice_stock_management_stock_path
      stock_attributes = attributes_for(:stock_attribute)

      post backoffice_stock_management_stocks_path, params: { stock: stock_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      stock = create(:stock,
                     entry_measure_quantity_list: 0)

      sign_in admin

      get backoffice_stock_management_stocks_path

      expect(response).to have_http_status(:success)

      delete backoffice_stock_management_stock_path(stock)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_stocks_path)
    end

    it 'returns http unauthorized' do
      stock = create(:stock)
      delete backoffice_stock_management_stock_path(stock)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http unprocessable entity' do
      stock = create(:stock)

      create(:entry, stock: stock)

      sign_in admin

      get backoffice_stock_management_stocks_path

      expect(response).to have_http_status(:success)

      delete backoffice_stock_management_stock_path(stock)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
