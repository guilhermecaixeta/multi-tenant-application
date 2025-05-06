# frozen_string_literal: true

# Unit test model
RSpec.describe Organization do
  subject { build(:organization) }

  describe 'Validations' do
    it 'is valid when there is no missing field' do
      expect(subject).to be_valid
    end

    it 'is invalid when name is missing' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when domain is missing' do
      subject.domain = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:domain].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when email is missing' do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when name is too short' do
      subject.name = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is invalid when domain is too short' do
      subject.domain = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:domain].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is invalid when email is too short' do
      subject.email = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.too_short', count: 8)
    end

    it 'is invalid when name is too long' do
      subject.name = (0..256).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:name].first).to eq I18n.t('errors.messages.too_long', count: 255)
    end

    it 'is invalid when name is too long' do
      subject.domain = (0..256).map { 'a' }.join
      expect(subject).not_to be_valid
      expect(subject.errors[:domain].first).to eq I18n.t('errors.messages.too_long', count: 255)
    end

    it 'is invalid when email is invalid' do
      subject.email = 'test.test.com'
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.invalid')
    end

    it 'is invalid when try to delete organization and has users' do
      organization = create(:organization)

      organization.users << create(:user)

      organization.valid?(:delete)
      expect(organization.errors[:base].first).to eq I18n.t('errors.messages.can_not_be_deleted',
                                                            attribute: described_class.model_name.human,
                                                            reason: I18n.t('errors.messages.reasons.has_users'))
    end
  end

  describe 'Callbacks' do
    it 'is code created before save' do
      subject.save!
      expect(subject.code).not_to be_nil
    end

    it 'is schema created after save a new organization' do
      subject.save!
      expect(Apartment.tenant_names).not_to be_nil
    end
  end

  describe 'Associations' do
    it 'is valid when has association with organization users' do
      expect(subject).to have_many(:organization_users)
    end

    it 'is valid when has association throught organization users with users' do
      expect(subject).to have_many(:users)
    end
  end

  describe 'Scopes' do
    it 'is valid when returns all valid organizations' do
      create(:organization)
      create(:organization,
             access_control: build(:access_control,
                                   active: false,
                                   active_from: Time.zone.today))
      create(:organization,
             access_control: build(:access_control,
                                   active_from: Time.zone.today,
                                   active_until: Time.zone.today + 7))

      expect(described_class.only_active.count).to eq 2
    end
  end
end
