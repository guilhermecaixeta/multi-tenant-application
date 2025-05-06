# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProfile do
  describe 'Validations' do
    subject(:organization_profile) { build(:organization_profile) }

    it 'is valid when' do
      expect(organization_profile).to be_valid
    end

    it 'is invalid when slogan is missing' do
      organization_profile.slogan = nil
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:slogan].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when about is missing' do
      organization_profile.about = nil
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:about].first).to eq I18n.t('errors.messages.blank')
    end

    it 'is invalid when slogan is too short' do
      organization_profile.slogan = 'aaa'
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:slogan].first).to eq I18n.t('errors.messages.too_short', count: 10)
    end

    it 'is invalid when about is too short' do
      organization_profile.about = 'aaa'
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:about].first).to eq I18n.t('errors.messages.too_short', count: 10)
    end

    it 'is invalid when slogan is too long' do
      organization_profile.slogan = (0..256).map { 'a' }.join
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:slogan].first).to eq I18n.t('errors.messages.too_long', count: 255)
    end

    it 'is invalid when about is too long' do
      organization_profile.about = (0..801).map { 'a' }.join
      expect(organization_profile).not_to be_valid
      expect(organization_profile.errors[:about].first).to eq I18n.t('errors.messages.too_long', count: 800)
    end
  end
end
