# frozen_string_literal: true
# typed: true

require 'random/formatter'
# Callback
class OrganizationCallbacks
  extend T::Sig

  sig { params(model: Organization).void }
  def before_create(model)
    model.code = Random.uuid
  end

  sig { params(model: Organization).void }
  def after_create(model)
    Apartment::Tenant.create(model.tenant_name)
    seed_tenant(model)
  end

  sig { params(model: Organization).void }
  def after_destroy(model)
    Apartment::Tenant.drop(model.tenant_name)
  end

  private

  def seed_tenant(model) # rubocop:disable Metrics/MethodLength
    # Create default records for the new tenant
    time_now = Time.zone.now
    Rails.logger.debug "== Adding categories ==\n"
    categories = [{ name: 'Massa',
                    created_at: time_now,
                    updated_at: time_now },
                  { name: 'Recheio',
                    created_at: time_now,
                    updated_at: time_now },
                  { name: 'Cobertura',
                    created_at: time_now,
                    updated_at: time_now }]

    Rails.logger.debug "== Adding units ==\n"
    units = [{ long_name: 'Quilograma',
               short_name: 'Kg',
               quantity: 1000,
               unit_type: Unit.unit_types[:weight],
               is_default: false,
               created_at: time_now,
               updated_at: time_now },
             { long_name: 'Grama',
               short_name: 'g',
               quantity: 1,
               unit_type: Unit.unit_types[:weight],
               is_default: true,
               created_at: time_now,
               updated_at: time_now },
             { long_name: 'Litro',
               short_name: 'Lt',
               quantity: 1000,
               is_default: false,
               unit_type: Unit.unit_types[:volume],
               created_at: time_now,
               updated_at: time_now },
             { long_name: 'Mililitro',
               short_name: 'ml',
               quantity: 1,
               unit_type: Unit.unit_types[:volume],
               is_default: true,
               created_at: time_now,
               updated_at: time_now },
             { long_name: 'Dúzia',
               short_name: 'Dz',
               quantity: 12,
               unit_type: Unit.unit_types[:decimal],
               is_default: false,
               created_at: time_now,
               updated_at: time_now },
             { long_name: 'Unidade',
               short_name: 'Un',
               quantity: 1,
               unit_type: Unit.unit_types[:decimal],
               is_default: true,
               created_at: time_now,
               updated_at: time_now }]

    model.run_on_tenant proc {
                          Category.insert_all(categories)
                          Unit.insert_all(units)
                        }
    Rails.logger.debug "== Done ==\n"
  end
end
