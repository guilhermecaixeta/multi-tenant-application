# frozen_string_literal: true

RSpec.describe 'Backoffice::UserSettings::Users' do
  include_context 'users',
                  'Backoffice::UserSettings::Users',
                  [
                    'Backoffice::UserSettings::Users::EditSecurity',
                    'Backoffice::UserSettings::Users::EditProfile',
                    'Backoffice::UserSettings::Users::UpdateSecurity',
                    'Backoffice::UserSettings::Users::UpdateProfile'
                  ],
                  [
                    'Backoffice::UserSettings::Users::EditSecurity',
                    'Backoffice::UserSettings::Users::EditProfile',
                    'Backoffice::UserSettings::Users::UpdateSecurity',
                    'Backoffice::UserSettings::Users::UpdateProfile'
                  ]

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin

      get backoffice_user_settings_users_path

      expect(response).to have_http_status(:success)
    end

    it 'returns http unauthorized' do
      get backoffice_user_settings_users_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /new' do
    it 'returns http success' do
      sign_in admin

      get new_backoffice_user_settings_user_path

      expect(response).to render_template(:new)

      post backoffice_user_settings_users_path,
           params: { user: attributes_for(:user_for_attribute) }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_user_settings_users_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      post backoffice_user_settings_users_path,
           params: { user: attributes_for(:user_for_attribute) }

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http redirect' do
      get new_backoffice_user_settings_user_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get new_backoffice_user_settings_user_path

      expect(response).to render_template(:new)

      post backoffice_user_settings_users_path,
           params: { user: attributes_for(:user_for_attribute, email: nil) }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /edit' do
    it 'returns http success' do
      sign_in admin

      get edit_backoffice_user_settings_user_path(admin)

      expect(response).to render_template(:edit)

      put backoffice_user_settings_user_path(admin), params: { user: { name: 'Rename User' } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_user_settings_users_path)
    end

    it 'returns http forbidden' do
      sign_in operator

      get edit_backoffice_user_settings_user_path(admin)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      get edit_backoffice_user_settings_user_path(admin)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get edit_backoffice_user_settings_user_path(admin)

      expect(response).to render_template(:edit)

      put backoffice_user_settings_user_path(admin),
          params: {
            user: {
              profile_attributes: {
                id: admin.id,
                first_name: ''
              }
            }
          }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /destroy' do
    skip 'returns http success' do
      sign_in admin

      get backoffice_user_settings_users_path

      expect(response).to render_template(:index)

      delete backoffice_user_settings_user_path(operator)

      expect(response).to have_http_status(:redirect)

      expect(response).to redirect_to(backoffice_user_settings_users_path)
    end

    it 'returns http unauthorized' do
      delete backoffice_user_settings_user_path(admin)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get backoffice_user_settings_users_path

      expect(response).to render_template(:index)

      delete backoffice_user_settings_user_path(admin)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /profile' do
    let(:setup_session) do
      allow_any_instance_of(Backoffice::UserSettings::UsersController).to receive(:session) # rubocop:disable RSpec/AnyInstance
        .and_return({ previous_change_action_url: root_path })
    end

    it 'returns http success' do
      sign_in admin

      get edit_profile_backoffice_user_settings_users_path

      expect(response).to have_http_status(:ok)

      patch update_profile_backoffice_user_settings_users_path,
            params: {
              user: {
                profile_attributes: {
                  id: admin.id,
                  first_name: 'new name'
                }
              }
            }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(backoffice_user_settings_users_path)
    end

    it 'returns http success as operator' do
      sign_in operator

      get edit_profile_backoffice_user_settings_users_path

      expect(response).to have_http_status(:ok)

      setup_session

      patch update_profile_backoffice_user_settings_users_path,
            params: {
              user: {
                profile_attributes: {
                  id: operator.id,
                  first_name: 'new name'
                }
              }
            }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it 'returns http forbidden' do
      sign_in create :user

      get edit_profile_backoffice_user_settings_users_path

      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns http unauthorized' do
      get edit_profile_backoffice_user_settings_users_path

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns http unprocessable entity' do
      sign_in admin

      get edit_profile_backoffice_user_settings_users_path

      expect(response).to have_http_status(:ok)

      patch update_profile_backoffice_user_settings_users_path,
            params: {
              user: {
                profile_attributes: {
                  id: admin.id,
                  first_name: ''
                }
              }
            }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
