# frozen_string_literal: true

class SetupAppOnStartupJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    if Rails.application.credentials&.authorization&.migrate
      Rails.logger.info do
        "== Migrating authorizations v:#{Rails.application.credentials&.authorization&.version} ==\n"
      end
      `rails authorization:migrate`
    end

    Rails.logger.info { "== Setup authorization ==\n" }
    `rails authorization:setup`

    Rails.logger.info { "== Adding User Admin ==\n" }
    `rails prod:admin`
  end
end
