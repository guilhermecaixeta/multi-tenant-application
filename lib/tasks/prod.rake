# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

require 'random/formatter'

namespace :prod do
  desc 'Production setup'
  task setup: :environment do
    next unless Rails.env.production?

    Rails.logger.info { '=> Scheduling startup job' }
    SetupAppOnStartupJob.perform_later
  end

  desc 'Generate admin user'
  task admin: :environment do
    next if User.exists?
    next unless Rails.env.production?

    Rails.logger.info "== Adding admin user ==\n"

    admin_role = Rails.configuration.x.authorization.default_roles.first

    time_now = Time.zone.now

    admin_profile = Profile.new(first_name: 'Admin',
                                last_name: 'Master',
                                birthdate: '1990-01-01')
    admin = User.create(
      access_control: AccessControl.new(active: true),
      profile: admin_profile,
      email: Rails.configuration.x.authorization.default_user_email,
      confirmed_at: time_now,
      user_roles: [UserRole.new(role_id: Role.select(:id).find_by(name: admin_role[:name]).id)]
    )
    admin.skip_confirmation!
    admin.skip_confirmation_notification!
    Rails.logger.info "== Done ==\n"
  end
end
# rubocop:enable Metrics/BlockLength
