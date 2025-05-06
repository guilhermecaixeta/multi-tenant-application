FactoryBot.define do
  factory :user_role do
    transient { custom_permissions { [] } }
    transient { role_name { 'Administrator' } }
    role { create(:role, name: role_name, custom_permissions:) }
  end
end
