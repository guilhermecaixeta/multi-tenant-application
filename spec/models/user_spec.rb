# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject do
    build(:user)
  end

  describe 'Validations' do
    it 'is valid when has all required attributes' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when email is missing' do
      subject.email = ''
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when profile is missing' do
      subject.profile = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:profile].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is not valid when password is too weak' do
      subject.password = '123abc123'
      expect(subject).not_to be_valid
      expect(subject.errors[:password].first).to eq I18n.t('errors.messages.password.password_strength')
    end

    it 'is not valid when password does not matches' do
      subject.password_confirmation = Faker::Internet.password(min_length: 20,
                                                               max_length: 128,
                                                               mix_case: true,
                                                               special_characters: true)
      expect(subject).not_to be_valid
      expect(subject.errors[:password_confirmation].first).to eq I18n.t('errors.messages.confirmation',
                                                                        attribute: described_class
                                                                        .human_attribute_name(:password))
    end

    it 'is not valid when email is too long' do
      subject.email = "#{Faker::Alphanumeric.alphanumeric(number: 129)}@acme.com"
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.too_long', count: 128)
    end

    it 'is invalid when email is invalid' do
      subject.email = 'test.test.com'
      expect(subject).not_to be_valid
      expect(subject.errors[:email].first).to eq I18n.t('errors.messages.invalid')
    end
  end

  describe 'Custom Validations' do
    subject do
      create(:user, password: 's!123Abc123Esd.', password_confirmation: 's!123Abc123Esd.')
    end

    let(:password) do
      Faker::Internet.password(min_length: 20,
                               max_length: 128,
                               mix_case: true,
                               special_characters: true)
    end

    it 'is valid when all requirements is matched' do
      subject.password = password
      subject.password_confirmation = password
      expect(subject).to be_valid(:update_password)
    end

    it 'is invalid when new password is equals previous one' do
      subject
      existing_user = described_class.first
      expect(existing_user.update_with_password({ current_password: 's!123Abc123Esd.',
                                                  password: 's!123Abc123Esd.',
                                                  password_confirmation: 's!123Abc123Esd.' })).to be_falsey
      expect(existing_user.errors[:password].first).to eq I18n.t('errors.messages.password.equals_last_password')
    end

    it 'is invalid when new password does not matches to new one' do
      subject
      existing_user = described_class.first
      expect(existing_user.update_with_password({ current_password: 's!123Abc123Esd.',
                                                  password: 's!123Abc123EsdAd.',
                                                  password_confirmation: 's!123Abc123EsdAa.' })).to be_falsey
      expect(existing_user.errors[:password_confirmation].first).to eq I18n.t('errors.messages.confirmation',
                                                                              attribute: described_class
                                                                              .human_attribute_name(:password))
    end

    it 'is invalid when current password is wrong' do
      subject
      existing_user = described_class.first
      expect(existing_user.update_with_password({ current_password: 's!123Abc123EsdA.',
                                                  password: 's!123Abc123EsdAd.',
                                                  password_confirmation: 's!123Abc123EsdAd.' })).to be_falsey
      expect(existing_user.errors[:current_password].first).to eq I18n.t('errors.messages.password.invalid')
    end

    it 'is invalid when current password is blank' do
      subject
      existing_user = described_class.first
      expect(existing_user.update_with_password({ current_password: '',
                                                  password: 's!123Abc123EsdAd.',
                                                  password_confirmation: 's!123Abc123EsdAd.' })).to be_falsey
      expect(existing_user.errors[:current_password].first).to eq I18n.t('errors.messages.blank')
    end
  end

  describe 'Callbacks' do
    it 'is valid when callback generate a new password when is not provided' do
      subject.password = nil
      subject.password_confirmation = nil

      subject.save!

      expect(subject.password).to be_truthy
      expect(subject.password.size).to eq 8
    end

    it "is valid when callback send email after user's creation" do
      ActiveJob::Base.queue_adapter = :test

      subject.password = nil
      subject.password_confirmation = nil

      subject.save!

      expect { UserMailer.welcome.deliver_later }.to have_enqueued_mail(UserMailer, :welcome)
    end
  end

  describe 'Associations' do
    it 'is valid when has have one association with profile' do
      expect(subject).to have_one(:profile)
    end

    it 'is valid when has association user roles' do
      expect(subject).to have_many(:user_roles)
    end

    it 'is valid when has association with roles through user roles' do
      expect(subject).to have_many(:roles)
    end

    it 'is valid when has association with permissions through roles' do
      expect(subject).to have_many(:permissions)
    end
  end
end
