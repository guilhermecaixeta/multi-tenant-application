# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::ApplicationManagement::Roles' do
  include_context 'users', 'Backoffice::ApplicationManagement::Roles'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_application_management_roles_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_application_management_roles_path

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get backoffice_application_management_roles_path

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_application_management_role_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)

      role_attributes = attributes_for(:role, name: 'temp')

      post backoffice_application_management_roles_path, params: { role: role_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_application_management_roles_path)
    end

    it 'returns http unauthorized' do
      role_attributes = create(:role, name: 'temp')

      post backoffice_application_management_roles_path, params: { role: role_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      role_attributes = attributes_for(:role)

      post backoffice_application_management_roles_path, params: { role: role_attributes }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get new_backoffice_application_management_role_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)

      role_attribute = attributes_for(:role, name: 'sa')

      post backoffice_application_management_roles_path, params: { role: role_attribute }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /edit' do
    it 'returns http success' do
      sign_in admin

      role = create(:role, name: 'temp')

      get edit_backoffice_application_management_role_path(role)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)

      put backoffice_application_management_role_path(role), params: { role: { name: 'New name' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_application_management_roles_path)
    end

    it 'returns http unauthorized' do
      role = create(:role, name: 'temp')

      get edit_backoffice_application_management_role_path(role)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      role = create(:role, name: 'temp')

      get edit_backoffice_application_management_role_path(role)

      follow_redirect!
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      role = create(:role, name: 'temp')

      get edit_backoffice_application_management_role_path(role)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)

      put backoffice_application_management_role_path(role), params: { role: { name: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      sign_in admin

      role = create(:role, name: 'temp')

      get backoffice_application_management_roles_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      delete backoffice_application_management_role_path(role)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'returns http unauthorized' do
      role = create(:role, name: 'temp')

      delete backoffice_application_management_role_path(role)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      role = create(:role, name: 'temp')

      delete backoffice_application_management_role_path(role)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      role = admin.roles.first

      get backoffice_application_management_roles_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      delete backoffice_application_management_role_path(role)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
