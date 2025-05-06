# frozen_string_literal: true

RSpec.describe Profile do
  subject { build(:profile) }

  describe 'Validations' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when first name is missing' do
      subject.first_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:first_name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when last name is missing' do
      subject.last_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:last_name].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when birthdate is missing' do
      subject.birthdate = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:birthdate].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when user is missing' do
      subject.user = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:user].first).to eq I18n.t('errors.messages.required')
    end

    it 'is not valid when first name is too short' do
      subject.first_name = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:first_name].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end

    it 'is not valid when last name is too short' do
      subject.last_name = 'aa'
      expect(subject).not_to be_valid
      expect(subject.errors[:last_name].first).to eq I18n.t('errors.messages.too_short', count: 3)
    end
  end

  describe 'Associations' do
    it 'is valid when has have one association with user' do
      expect(subject).to belong_to(:user)
    end

    it 'is valid when has association with profile addresses' do
      expect(subject).to have_many(:profile_addresses)
    end

    it 'is valid when has association with profile phones' do
      expect(subject).to have_many(:profile_phones)
    end

    it 'is valid when has association with addresses through profile addresses' do
      expect(subject).to have_many(:addresses)
    end

    it 'is valid when has association with phones through profile phones' do
      expect(subject).to have_many(:phones)
    end
  end
end
