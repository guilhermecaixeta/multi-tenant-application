# # frozen_string_literal: true

# RSpec.describe 'Backoffice::Errors' do
#   include_context 'users',
#                   'Backoffice::Errors::Forbidden',
#                   [
#                     'Backoffice::Errors::NotFound',
#                     'Backoffice::Errors::Unacceptable',
#                     'Backoffice::Errors::InternalError',
#                     'Backoffice::StockManagement::Entries::Update',
#                     'Backoffice::StockManagement::Entries::Create'
#                   ]

#   let(:entry) { instance_double(Entry) }

#   describe 'GET /not_found' do
#     it 'returns http not found' do
#       sign_in admin

#       allow(Entry)
#         .to receive(:new)
#         .and_return(entry)

#       allow(entry)
#         .to receive(:update)
#         .and_raise(ActiveRecord::RecordNotFound)

#       entry_attributes = attributes_for(:entry_attribute)

#       put backoffice_stock_management_entry_path(1), params: { entry: entry_attributes }

#       expect(response).to have_http_status(:not_found)
#     end
#   end

#   describe 'GET /bad_request' do
#     it 'returns http bad request' do
#       sign_in admin

#       allow(Entry)
#         .to receive(:new)
#         .and_return(entry)

#       allow(entry)
#         .to receive(:create)
#         .and_raise(DomainErrors::BadRequestError)

#       entry_attributes = attributes_for(:entry_attribute)

#       post backoffice_stock_management_entries_path, params: { entry: entry_attributes }

#       expect(response).to have_http_status(:bad_request)
#     end
#   end

#   describe 'GET /inactive' do
#     it 'returns http forbidden' do
#       operator.access_control.active = false
#       operator.access_control.save!

#       sign_in operator

#       get backoffice_path
#       follow_redirect!

#       expect(response).to have_http_status(:forbidden)
#     end
#   end
# end
