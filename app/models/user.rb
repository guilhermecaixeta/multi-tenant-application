# frozen_string_literal: true
# typed: true

# Class User
class User < ApplicationRecord
  include ControlableConcern
  extend T::Sig

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable # :validatable,
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :confirmable,
         :lockable,
         :trackable

  before_create UserCallbacks.new
  after_create UserCallbacks.new
  before_update UserCallbacks.new

  has_one :profile,
          dependent: :destroy

  has_many :user_roles,
           dependent: :destroy

  has_many :organization_users,
           dependent: :destroy

  has_many :roles,
           through: :user_roles

  has_many :permissions,
           through: :roles

  has_many :organizations,
           through: :organization_users

  accepts_nested_attributes_for :profile,
                                :user_roles,
                                :access_control,
                                allow_destroy: true

  sig { returns(T::Boolean) }
  def admin?
    admin_role = Rails.configuration.x.authorization.default_roles.first

    @admin ||= roles.any? { |role| role.name.casecmp?(admin_role[:name]) }
  end

  sig { returns(T::Boolean) }
  def organizations?
    @organizations ||= organizations&.any?
  end

  sig { returns(T.nilable(Organization)) }
  def principal_organization
    return nil unless organizations?

    @principal_organization ||= T.must(organization_users.find(&:principal)).organization
  end

  sig { params(organization_id: Integer).returns(Organization) }
  def organization_by_id(organization_id)
    T.must(organizations.find { |org| org.id == organization_id })
  end

  sig { returns(T::Boolean) }
  def active?
    return false unless T.must(access_control).active?

    return true unless organizations?

    organizations.any?(&:active?)
  end

  sig { void }
  def reset_password!
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_sent_at = Time.zone.today
    self.reset_password_token = hashed
    self.force_password_change = false
    save

    UserMailer.reset_password_instructions(self, raw).deliver_later!
  end

  sig { params(params: T.any(ActionController::Parameters, Hash)).returns(T::Boolean) }
  def update_with_password(params)
    self.force_password_change = false

    current_password = params.delete(:current_password)

    assign_attributes(params)

    is_valid = valid?(:password_update)

    if current_password.blank?
      errors.add(:current_password,
                 :blank,
                 message: I18n.t('errors.messages.blank'))
      is_valid = false
    end

    unless Devise::Encryptor.compare(self.class, encrypted_password_was, current_password)
      errors.add(:current_password,
                 :invalid,
                 message: I18n.t('errors.messages.password.invalid'))

      is_valid = false
    end

    if is_valid
      save
      return true
    end

    false
  end
end
