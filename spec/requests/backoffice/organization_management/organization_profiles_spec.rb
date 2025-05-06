# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::OrganizationManagement::OrganizationProfiles' do
  include_context 'users',
                  'Backoffice::OrganizationManagement::OrganizationProfiles'

  let!(:organization) { singleton(:organization) }

  let(:setup_session) do
    allow_any_instance_of(Rack::Request).to receive(:session) # rubocop:disable RSpec/AnyInstance
      .and_return({ organization_id: organization.id })
  end

  describe 'PUT /edit' do
    it 'returns http success' do
      sign_in admin
      setup_session

      put update_backoffice_organization_management_organization_profiles_path,
          params: { organization_profile: { about: Faker::Lorem.sentence(word_count: 20) } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin
      setup_session

      put update_backoffice_organization_management_organization_profiles_path,
          params: { organization_profile: { about: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http forbidden' do
      sign_in operator
      setup_session

      put update_backoffice_organization_management_organization_profiles_path,
          params: { organization: { name: 'New name' } }
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      put update_backoffice_organization_management_organization_profiles_path,
          params: { organization: { name: 'New name' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
