# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::CatalogsManagement::CatalogCategories' do
  include_context 'users', 'Backoffice::CatalogsManagement::CatalogCategories'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_catalogs_management_catalog_categories_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'returns http unauthorized' do
      get backoffice_catalogs_management_catalog_categories_path

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get backoffice_catalogs_management_catalog_categories_path
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /new' do
    let(:attributes) { attributes_for(:catalog_category_for_attributes) }

    it 'returns http success' do
      sign_in admin

      get new_backoffice_catalogs_management_catalog_category_path
      expect(response).to render_template(:new)

      post backoffice_catalogs_management_catalog_categories_path,
           params: { catalog_category: attributes }

      expect(response).to redirect_to(backoffice_catalogs_management_catalog_categories_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      attributes[:title] = nil

      post backoffice_catalogs_management_catalog_categories_path,
           params: { catalog_category: attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      attributes[:title] = nil

      post backoffice_catalogs_management_catalog_categories_path,
           params: { catalog_category: attributes }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      post backoffice_catalogs_management_catalog_categories_path,
           params: attributes
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT/PATCH /edit' do
    let!(:catalog_category) { create(:catalog_category) }

    it 'returns http success' do
      sign_in admin

      get edit_backoffice_catalogs_management_catalog_category_path(catalog_category)
      expect(response).to render_template(:edit)

      put backoffice_catalogs_management_catalog_category_path(catalog_category),
          params: { catalog_category: { name: 'new name' } }

      expect(response).to redirect_to(backoffice_catalogs_management_catalog_categories_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      put backoffice_catalogs_management_catalog_category_path(catalog_category),
          params: { catalog_category: { title: 'aa' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      put backoffice_catalogs_management_catalog_category_path(catalog_category),
          params: { catalog_category: { title: 'aa' } }

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      put backoffice_catalogs_management_catalog_category_path(catalog_category),
          params: { catalog_category: { title: 'new name' } }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /destroy' do
    let!(:catalog_category) { create(:catalog_category) }

    it 'returns http success' do
      sign_in admin

      delete backoffice_catalogs_management_catalog_category_path(catalog_category)
      follow_redirect!

      expect(response).to have_http_status(:success)
    end

    it 'returns http unprocessable entity', skip: 'Cannot be reproduced' do
      sign_in admin

      delete backoffice_catalogs_management_catalog_categories_path(catalog_category)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unauthorized' do
      delete backoffice_catalogs_management_catalog_category_path(catalog_category)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      delete backoffice_catalogs_management_catalog_category_path(catalog_category)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
