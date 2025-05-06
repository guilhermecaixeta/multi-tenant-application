# frozen_string_literal: true

RSpec.describe 'Backoffice::ApplicationManagement::Permissions' do
  include_context 'users', 'Backoffice::ApplicationManagement::Permissions'

  let(:backoffice_application_management_permission_path) do
    '/backoffice/application-management/permissions'
  end

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_application_management_permissions_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_application_management_permissions_path

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get backoffice_application_management_permissions_path

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /new' do
    it 'returns http not found' do
      sign_in admin

      role_attributes = attributes_for(:role, name: 'temp')

      post backoffice_application_management_permission_path, params: { role: role_attributes }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /edit' do
    it 'returns http not found' do
      sign_in admin

      permission = create(:permission)

      put "#{backoffice_application_management_permission_path}/#{permission.id}",
          params: { permission: { name: 'New name' } }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http not found' do
      sign_in admin

      permission = create(:permission)

      delete "#{backoffice_application_management_permission_path}/#{permission.id}"

      expect(response).to have_http_status(:not_found)
    end
  end
end
