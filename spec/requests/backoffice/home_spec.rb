# frozen_string_literal: true

RSpec.describe 'Backoffice::Home' do
  include_context 'users',
                  'Backoffice::Home'

  describe 'GET /index' do
    it 'returns http success' do
      sign_in admin
      get backoffice_home_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /index when user is not logged' do
    it 'returns http return error' do
      get backoffice_home_index_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
