# frozen_string_literal: true
# typed: true

# Mailer
class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def default_email
    'nao-responda@business-manager.com'
  end
end
