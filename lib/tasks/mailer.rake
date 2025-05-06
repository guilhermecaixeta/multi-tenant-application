# frozen_string_literal: true

# Mailer task
namespace :mailer do
  desc 'Reset and send a email for all users'
  task pepper_migration: :environment do
    return unless Rails.application.credentials&.devise&.pepper_migration

    reset_password_link = Rails.application
                               .routes
                               .url_helpers
                               .new_user_password_url(host: Rails.application.credentials&.host&.fallback)

    User
      .joins(:access_control)
      .where(access_control: { active: true })
      .find_each do |user|
        puts "sending announcements email to user #{user.id}"
        UserMailer.announcements(user,
                                 I18n.t('email.warning.pepper_migration.subject'),
                                 I18n.t('email.warning.pepper_migration.instruction_message',
                                        link: reset_password_link)).deliver_later(wait: 10.minutes)
      end
  end
end
