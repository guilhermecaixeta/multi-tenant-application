# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer do
  let(:generated_password) { Devise.friendly_token.first(8) }

  describe 'Welcome' do
    it 'sends temp password email' do
      user = build(:user)
      mail = described_class.welcome(user, generated_password)
      expect(mail.subject).to eq(I18n.t('email.welcome.advise_message',
                                        name: user.profile.full_name))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials&.devise&.email_from])
    end

    it 'sends temp password email when user belongs to organization' do
      user_organization = build(:user_organization)
      mail = described_class.welcome(user_organization, generated_password)
      expect(mail.subject).to eq(I18n.t('email.welcome.advise_message',
                                        name: user_organization.profile.full_name))
      expect(mail.to).to eq([user_organization.email])
      expect(mail.from).to eq([user_organization.principal_organization.email])
    end

    it 'sends welcome email' do
      user = build(:user)
      mail = described_class.welcome(user, generated_password)
      expect(mail.body.encoded).to match(generated_password)
    end
  end

  describe 'Reset Password Instructions' do
    it 'sends password recover email' do
      user = build(:user)
      mail = described_class.reset_password_instructions(user, generated_password)
      expect(mail.subject).to eq(I18n.t('devise.mailer.reset_password_instructions.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials&.devise&.email_from])
    end
  end

  describe 'Password Changed' do
    it 'sends password changed email' do
      user = build(:user)
      mail = described_class.password_change(user, generated_password)
      expect(mail.subject).to eq(I18n.t('devise.mailer.password_changed.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials&.devise&.email_from])
    end
  end

  describe 'Email Changed' do
    it 'sends email changed email' do
      user = build(:user)
      mail = described_class.email_changed(user, generated_password)
      expect(mail.subject).to eq(I18n.t('devise.mailer.email_changed.subject'))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials&.devise&.email_from])
    end
  end
end
