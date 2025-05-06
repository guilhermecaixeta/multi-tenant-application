# frozen_string_literal: true

namespace :authorization do
  desc 'Setup'
  task setup: :environment do
    puts "== Adding roles ==\n#{`rails authorization:roles`}"
    puts "== Adding permissions ==\n#{`rails authorization:permissions`}"
    puts "== Adding attaching permissions to roles ==\n#{`rails authorization:attach`}"
  end

  desc 'Migrate RBAC'
  task migrate: :environment do
    puts 'Dettaching all roles from users'
    UserRole.delete_all

    puts 'Dettaching all roles from permissions'
    RolePermission.delete_all

    puts 'Deleting all roles'
    Role.delete_all

    puts 'Deleting all permissions'
    Permission.delete_all

    puts "== Setup new RBAC ==\n#{`rails authorization:setup`}"
  end

  desc 'Adding new roles'
  task roles: :environment do
    default_roles = Rails.configuration.x.authorization.default_roles
    existing_roles = Role.all

    puts "== Checking roles ==\n"
    new_roles = if existing_roles.empty?
                  default_roles.map do |role|
                    { name: role[:name], admin: role[:admin] }
                  end
                else
                  filtered_roles = default_roles.filter do |role|
                    existing_roles.none? { |existing_role| existing_role.name == role[:name] }
                  end

                  filtered_roles.map do |role|
                    { name: role[:name] }
                  end
                end

    if new_roles.any?
      puts { "== There is #{new_roles.count} to be added ==\n" }
      Role.upsert_all new_roles, record_timestamps: true
    else
      puts "== No role was found ==\n"
    end
    puts '== Done =='
  end

  desc 'Adding new permissions'
  task permissions: :environment do
    allowed_routes_pattern = /#{Rails.configuration.x.authorization.allowed_routes_pattern}/

    puts "== Checking permissions ==\n"
    routes = Rails.application.routes.routes.map do |route|
      { controller: route.defaults[:controller], action: route.defaults[:action] }
    end

    default_permissions = routes.uniq
                                .filter { |route| allowed_routes_pattern.match? route[:controller] }

    puts default_permissions.join "\n"

    existing_permissions = Permission.all

    if existing_permissions.any?
      default_permissions.delete_if do |permission|
        existing_permissions.any? do |existing_permission|
          existing_permission.scope.casecmp?("#{permission[:controller]}/#{permission[:action]}".camelize)
        end
      end
    end

    if default_permissions.any?
      puts "== There is #{default_permissions.count} permissions to be added ==\n"
      new_permissions = []
      default_permissions.map do |permission|
        new_permissions << { title: "#{permission[:controller].titleize} #{permission[:action].titleize}",
                             scope: "#{permission[:controller]}/#{permission[:action]}".camelize }
      end

      Permission.upsert_all new_permissions, record_timestamps: true
      puts "== Done! ==\n"
    else
      puts "== No new permissions was found ==\n"
    end
  end

  desc 'Attach roles to permissions'
  task attach: :environment do
    default_roles = Rails.configuration.x
                         .authorization
                         .default_roles
    existing_permissions = Permission.all
    existing_roles = Role
                     .includes(role_permissions: :permission)
                     .where(name: default_roles.pluck(:name))

    puts "== Attaching permissions to roles ==\n"
    existing_roles.each do |role|
      default_role = default_roles.find { |r| r[:name] == role.name }
      existing_permissions.each do |existing_permission|
        next if role.role_permissions.any? do |role_permission|
                  role_permission.permission.scope == existing_permission.scope
                end
        next if default_role[:except_permissions].any? do |exception|
          exception.match?(existing_permission.scope)
        end

        role.role_permissions << RolePermission
                                 .new(permission_id: existing_permission.id, role_id: role.id)
      end
      role.save!(validate: false)
    end
    puts "== Done ==\n"
  end
end
