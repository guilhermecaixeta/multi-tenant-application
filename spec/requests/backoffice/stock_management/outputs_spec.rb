# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::StockManagement::Outputs' do
  include_context 'users',
                  'Backoffice::StockManagement::Outputs'

  describe 'GET /index' do
    skip 'returns http success' do
      get backoffice_stock_management_outputs_path
      expect(response).to have_http_status(:success)
    end
  end
end
