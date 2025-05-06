# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Site::Contacts' do
  describe 'GET /index' do
    skip 'returns http success' do
      get '/contacts/index'
      expect(response).to have_http_status(:success)
    end
  end
end
