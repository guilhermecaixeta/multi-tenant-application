# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  subject { build(:role) }

  describe 'Validations' do
    it 'is valid when name matches all requirements' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when name is missing' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when name is smaller than 3 characteres' do
      subject.name = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is not valid when name is bigger than 255 characteres' do
      subject.name = (0..256).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_long', count: 255)
    end

    it 'is not valid when role is admin' do
      admin_role = create(:role, name: 'Administrator')

      admin_role.valid?(:delete)

      expect(admin_role.errors[:base].first).to eq I18n.t('errors.messages.can_not_be_deleted',
                                                          attribute: described_class.model_name.human,
                                                          reason: I18n.t('errors.messages.reasons.role_admin'))
    end

    it 'is not valid when role has user' do
      user = create(:user, role_name: 'Operator', custom_permissions_roles: ['Backoffice::UsersManagement::Index'])

      operator_role = user.roles.first

      operator_role.valid?(:delete)

      expect(operator_role.errors[:base].first).to eq I18n.t('errors.messages.can_not_be_deleted',
                                                             attribute: described_class.model_name.human,
                                                             reason: I18n.t('errors.messages.reasons.has_users'))
    end
  end

  describe 'Associations' do
    it 'is valid when has association with user roles' do
      expect(subject).to have_many(:user_roles)
    end

    it 'is valid when has association with role permissions' do
      expect(subject).to have_many(:role_permissions)
    end

    it 'is valid when has association with permissions through role permissions' do
      expect(subject).to have_many(:permissions)
    end
  end
end
