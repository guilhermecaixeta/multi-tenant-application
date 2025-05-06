# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Backoffice::Support::Units' do
  describe 'GET /index' do
    include_context 'users',
                    'Backoffice::Support::Units',
                    ['Backoffice::Support::Units::SelectUnitsByStockId']

    let(:headers) { { 'ACCEPT' => 'text/vnd.turbo-stream.html' } }
    let(:stock) { singleton(:stock) }

    around { |test| I18n.with_locale('pt-BR') { test.run } }

    it 'returns http success' do
      sign_in admin

      get(select_units_by_stock_id_backoffice_support_unit_path,
          params: {
            source_value: stock.id,
            destination_id: 'some_id',
            destination_name: 'some_name',
            destination_value: 0
          },
          headers:)

      expect(response.content_type).to eq('text/vnd.turbo-stream.html; charset=utf-8')
      expect(response).to have_http_status(:success)
    end

    it 'returns http not found' do
      sign_in admin

      get(select_units_by_stock_id_backoffice_support_unit_path,
          params: {
            source_value: 2,
            destination_id: 'some_id',
            destination_name: 'some_name',
            destination_value: 0
          },
          headers:)

      expect(response).to have_http_status(:success)
      expect(flash[:alert]).to eq(I18n.t('errors.messages.units_not_found'))
    end

    it 'returns http forbidden' do
      sign_in operator

      get(select_units_by_stock_id_backoffice_support_unit_path,
          params: {
            source_value: stock.id,
            destination_id: 'some_id',
            destination_name: 'some_name',
            destination_value: 0
          },
          headers:)
      follow_redirect!

      expect(response).to have_http_status(:forbidden)
    end
  end
end
