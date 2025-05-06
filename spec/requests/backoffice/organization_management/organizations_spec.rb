# frozen_string_literal: true

RSpec.describe 'Backoffice::OrganizationManagement::Organizations' do
  include_context 'users',
                  'Backoffice::OrganizationManagement::Organizations',
                  ['Backoffice::OrganizationManagement::Organizations::Select',
                   'Backoffice::OrganizationManagement::Organizations::Unselect']

  let!(:organization) do
    singleton(:organization)
  end

  let(:setup) do
    organization.users << admin
    organization.save!
    organization
  end

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_organization_management_organizations_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_organization_management_organizations_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http forbidden' do
      existing_organization = Organization.first
      existing_organization.access_control.active = false
      existing_organization.save!

      sign_in operator
      get backoffice_organization_management_organizations_path
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_organization_management_organization_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)

      post backoffice_organization_management_organizations_path,
           params: { organization: attributes_for(:organization_attributes) }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_organization_management_organizations_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      organization_attributes = attributes_for(:organization)

      organization_attributes[:name] = nil

      post backoffice_organization_management_organizations_path,
           params: { organization: organization_attributes }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http forbidden' do
      sign_in operator

      organization_attributes = attributes_for(:organization)

      post backoffice_organization_management_organizations_path,
           params: { organization: organization_attributes }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      organization_attributes = attributes_for(:organization)

      post backoffice_organization_management_organizations_path,
           params: { organization: organization_attributes }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'PUT /edit' do
    let!(:organization) { FactoryBot.singleton :organization }

    it 'returns http success' do
      sign_in admin

      get edit_backoffice_organization_management_organization_path(organization)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)

      put backoffice_organization_management_organization_path(organization),
          params: { organization: { name: 'New name' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_organization_management_organizations_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      put backoffice_organization_management_organization_path(organization),
          params: { organization: { name: 'aa' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http forbidden' do
      sign_in operator

      put backoffice_organization_management_organization_path(organization),
          params: { organization: { name: 'New name' } }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      org = FactoryBot.singleton :organization

      put backoffice_organization_management_organization_path(org),
          params: { organization: { name: 'New name' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      sign_in admin
      org = create(:organization)

      delete backoffice_organization_management_organization_path(org)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_organization_management_organizations_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      setup

      delete backoffice_organization_management_organization_path(organization)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http forbidden' do
      sign_in operator

      existing_organization = create(:organization)

      delete backoffice_organization_management_organization_path(existing_organization)

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      existing_organization = create(:organization)

      delete backoffice_organization_management_organization_path(existing_organization)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /select' do
    it 'return http success' do
      sign_in admin
      org = FactoryBot.singleton :organization

      post select_backoffice_organization_management_organization_path(org)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'return http not-found' do
      sign_in admin
      org = Organization.new(id: 3, name: 'Any')

      post select_backoffice_organization_management_organization_path(org)

      expect(response).to have_http_status(:not_found)
    end

    it 'return http forbidden' do
      sign_in operator
      org = FactoryBot.singleton :organization

      post select_backoffice_organization_management_organization_path(org)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'return http unauthorized' do
      org = FactoryBot.singleton :organization

      post select_backoffice_organization_management_organization_path(org)
      follow_redirect!

      expect(response).to render_template('users/sessions/new')
    end
  end

  describe 'DELETE /unselect' do
    it 'return http success' do
      sign_in admin
      org = FactoryBot.singleton :organization

      post select_backoffice_organization_management_organization_path(org)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      delete unselect_backoffice_organization_management_organizations_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'return http forbidden' do
      sign_in operator

      delete unselect_backoffice_organization_management_organizations_path
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'return http unauthorized' do
      delete unselect_backoffice_organization_management_organizations_path
      follow_redirect!

      expect(response).to render_template('users/sessions/new')
    end
  end
end
