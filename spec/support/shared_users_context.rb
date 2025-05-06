# frozen_string_literal: true

RSpec.shared_context 'users' do |controller_name, custom_admin_permissions = [], custom_operator_permissions = []| # rubocop:disable RSpec/ContextWording
  let!(:admin) do
    create(:user,
           custom_permissions_roles: custom_admin_permissions + ["#{controller_name}::Index",
                                                                 "#{controller_name}::New",
                                                                 "#{controller_name}::Create",
                                                                 "#{controller_name}::Edit",
                                                                 "#{controller_name}::Update",
                                                                 "#{controller_name}::Destroy"])
  end

  let!(:operator) do
    create(:user,
           role_name: 'Operator',
           custom_permissions_roles: custom_operator_permissions)
  end
end
