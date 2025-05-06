# frozen_string_literal: true

RSpec.describe 'Backoffice::StockManagement::Entries' do
  include_context 'users',
                  'Backoffice::StockManagement::Entries'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_stock_management_entries_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_stock_management_entries_path

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get backoffice_stock_management_entries_path

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_stock_management_entry_path

      expect(response).to render_template(:new)

      entry_attributes = attributes_for(:entry_attribute)

      post backoffice_stock_management_entries_path, params: { entry: entry_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_entries_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get new_backoffice_stock_management_entry_path

      expect(response).to render_template(:new)

      entry_attributes = attributes_for(:entry_attribute)

      entry_attributes[:total_items] = -1

      post backoffice_stock_management_entries_path, params: { entry: entry_attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      get new_backoffice_stock_management_entry_path
      entry_attributes = attributes_for(:entry_attribute)

      post backoffice_stock_management_entries_path, params: { entry: entry_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get new_backoffice_stock_management_entry_path

      entry_attributes = attributes_for(:entry_attribute)

      post backoffice_stock_management_entries_path, params: { entry: entry_attributes }

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT /edit' do
    it 'returns http success' do
      sign_in admin

      entry = create(:entry)

      get edit_backoffice_stock_management_entry_path(entry)

      expect(response).to render_template(:edit)

      put backoffice_stock_management_entry_path(entry), params: { entry: { quantity: 10 } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_entries_path)
    end

    it 'returns http unprocessable entity' do
      entry = create(:entry)

      sign_in admin

      get edit_backoffice_stock_management_entry_path(entry)

      expect(response).to render_template(:edit)

      put backoffice_stock_management_entry_path(entry), params: { entry: { total_items: -1 } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      entry = create(:entry)

      put backoffice_stock_management_entry_path(entry), params: { entry: { total_items: -1 } }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      entry = create(:entry)

      put backoffice_stock_management_entry_path(entry), params: { entry: { total_items: -1 } }

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      entry = create(:entry)

      sign_in admin

      get backoffice_stock_management_entries_path

      expect(response).to have_http_status(:success)

      delete backoffice_stock_management_entry_path(entry)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_stock_management_entries_path)
    end

    it 'returns http unauthorized' do
      entry = create(:entry)

      delete backoffice_stock_management_entry_path(entry)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      entry = create(:entry)

      delete backoffice_stock_management_entry_path(entry)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
