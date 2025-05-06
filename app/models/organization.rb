# frozen_string_literal: true
# typed: true

# Model
class Organization < ApplicationRecord
  include ControlableConcern
  extend T::Sig

  before_create OrganizationCallbacks.new
  after_create OrganizationCallbacks.new
  after_destroy OrganizationCallbacks.new

  has_one :organization_profile,
          dependent: :destroy

  has_many :organization_users
  has_many :organization_roles
  has_many :organization_phones
  has_many :organization_addresses
  has_many :organization_permissions

  has_many :users,
           through: :organization_users
  has_many :phones,
           through: :organization_phones
  has_many :address,
           through: :organization_addresses

  has_one_attached :logo

  accepts_nested_attributes_for :access_control,
                                :organization_roles,
                                :organization_permissions,
                                :organization_addresses,
                                :organization_phones,
                                :organization_profile,
                                allow_destroy: true

  def self.build(attributes = nil, &block)
    organization = super

    return organization if organization.is_a?(Array)

    organization.build_access_control if organization.access_control.blank?
    organization.build_organization_profile if organization.organization_profile.blank?

    organization
  end

  sig { returns(String) }
  def tenant_name
    @tenant_name ||= "organization_#{code}"
  end

  sig { params(proc: Proc).void }
  def run_on_tenant(proc)
    Apartment::Tenant.switch(tenant_name) do
      proc.call
    end
  end

  scope :only_active, lambda {
    joins(:access_control)
      .merge(AccessControl.only_active)
      .distinct
  }
end
