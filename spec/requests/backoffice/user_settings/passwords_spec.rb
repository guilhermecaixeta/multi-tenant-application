# frozen_string_literal: true

RSpec.describe 'Backoffice::UserSettings::Passwords' do
  include_context 'users',
                  'Backoffice::UserSettings::Passwords'

  let(:permissions) do
    [
      'Backoffice::UserSettings::Passwords::Edit',
      'Backoffice::UserSettings::Passwords::Update',
      'Backoffice::Home::Index'
    ]
  end

  describe 'GET /index' do
    it 'returns http success' do
      admin.force_password_change = true
      admin.save!

      sign_in admin

      get backoffice_home_index_path

      expect(response).to have_http_status(:redirect)

      follow_redirect!

      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH /edit' do
    it 'returns http success', skip: 'TODO: check the returned error' do
      user = create(:user,
                    force_password_change: true,
                    password: '12h5gydjKbw!',
                    password_confirmation: '12h5gydjKbw!',
                    role_name: 'Manager',
                    custom_permissions_roles: permissions)

      sign_in user

      patch update_security_backoffice_user_settings_users_path,
            params: { user: { current_password: '12h5gydjKbw!',
                              password: 'Azwvbnb12346!',
                              password_confirmation: 'Azwvbnb12346!' } }

      follow_redirect!

      expect(response).to have_http_status(:success)
    end

    it 'returns http unprocessable entity when passwords not matches' do
      user = create(:user,
                    force_password_change: true,
                    password: '12,hgydjkbw!',
                    password_confirmation: '12,hgydjkbw!',
                    role_name: 'Manager',
                    custom_permissions_roles: permissions)

      sign_in user

      patch update_security_backoffice_user_settings_users_path,
            params: { user: { current_password: '12,hgydjkbw!',
                              password: 'azwvbnAED2346!',
                              password_confirmation: 'azwvbnAED2346' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns http unprocessable entity when current password is equals password' do
      user = create(:user,
                    force_password_change: true,
                    password: '12,hgydjkbw!',
                    password_confirmation: '12,hgydjkbw!',
                    role_name: 'Manager',
                    custom_permissions_roles: permissions)

      sign_in user

      patch update_security_backoffice_user_settings_users_path,
            params: { user: { current_password: '12,hgydjkbw!',
                              password: '12,hgydjkbw!',
                              password_confirmation: '12,hgydjkbw!' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
