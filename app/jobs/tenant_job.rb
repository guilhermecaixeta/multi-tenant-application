# frozen_string_literal: true

# Tenant Job
class TenantJob < ApplicationJob
  def use_tenant(tenant_name)
    Apartment::Tenant.switch! tenant_name
  end
end
