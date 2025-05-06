# frozen_string_literal: true

# ./spec/requests/sessions_spec.rb
require 'rails_helper'

RSpec.describe 'Users::Sessions' do
  it 'signs user in and out' do
    user = create(:user,
                  custom_permissions_roles: ['Backoffice::Home::Index'])

    sign_in user
    get backoffice_path
    expect(response).to render_template(:index)

    sign_out user
    get backoffice_path
    expect(response).not_to render_template(:index)
  end
end
