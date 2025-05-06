# frozen_string_literal: true

RSpec.describe Item do
  subject { build(:item) }

  describe 'Validations' do
    it 'is valid when has all attributes required' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end

    it 'is not valid when quantity is missing' do
      subject.measure = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:measure].first).to eq I18n.t('errors.messages.blank')
    end
  end

  describe 'Associations' do
    it 'is valid when has belong to association with stock' do
      expect(subject).to belong_to(:stock).without_validating_presence
    end

    it 'is valid when has belong to association with product' do
      expect(subject).to belong_to(:catalog).without_validating_presence
    end

    it 'is valid when has belong to polymorphic association with quantity unit' do
      expect(subject).to have_one(:measure)
    end
  end
end
