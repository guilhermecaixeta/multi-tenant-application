# frozen_string_literal: true
# typed: true

# Mailer
class UserMailer < Devise::Mailer
  extend T::Sig
  include Devise::Controllers::UrlHelpers
  include DomainErrors

  layout 'mailer'
  default template_path: 'users/mailer',
          host: :default_host

  helper_method :default_host

  sig { params(user: User, generated_password: String).returns(T.untyped) }
  def welcome(user, generated_password)
    @user = user
    @generated_password = generated_password

    mail(
      to: email_address_with_name(@user.email, T.must(@user.profile).full_name),
      from: email_address_with_name(default_email, company_name),
      subject: t('email.welcome.advise_message', name: T.must(@user.profile).full_name)
    )
  end

  sig { params(record: User, token: String, _opts: T.untyped).returns(T.untyped) }
  def reset_password_instructions(record, token, _opts = {})
    @token = token
    @user = record
    mail(
      to: email_address_with_name(@user.email, T.must(@user.profile).full_name),
      from: email_address_with_name(default_email, company_name),
      subject: t('devise.mailer.reset_password_instructions.subject')
    )
  end

  sig { params(record: User, _opts: T.untyped).returns(T.untyped) }
  def email_changed(record, _opts = {})
    @user = record
    mail(
      to: email_address_with_name(@user.email, T.must(@user.profile).full_name),
      from: email_address_with_name(default_email, company_name),
      subject: t('devise.mailer.email_changed.subject')
    )
  end

  sig { params(record: User, _opts: T.untyped).returns(T.untyped) }
  def password_change(record, _opts = {})
    @user = record
    mail(
      to: email_address_with_name(@user.email, T.must(@user.profile).full_name),
      from: email_address_with_name(default_email, company_name),
      subject: t('devise.mailer.password_changed.subject')
    )
  end

  sig { params(record: User, subject: String, body: String).returns(T.untyped) }
  def announcements(record, subject, body)
    @body = body
    @user = record
    @subject = subject

    mail(
      to: email_address_with_name(@user.email, T.must(@user.profile).full_name),
      from: email_address_with_name(default_email, company_name),
      subject:
    )
  end

  sig { returns(String) }
  def default_host
    return "#{default_protocol}://#{Rails.application.credentials&.host&.fallback}" unless Apartment::Tenant.current

    domain = Organization.where(code: Apartment::Tenant.current.sub('organization_', '')).pick(:domain)

    if Rails.env.development?
      'http://localhost:3000'
    else
      "#{default_protocol}://#{domain}"
    end
  end

  def default_url_options
    { host: default_host, protocol: default_protocol }
  end

  private

  sig { returns(String) }
  def default_protocol
    Rails.env.development? ? 'http' : 'https'
  end

  sig { returns(String) }
  def company_name
    @company_name = @user.principal_organization&.name || Rails.configuration.x.application.name
  end

  sig { returns(String) }
  def default_email
    return Rails.application.credentials&.devise&.email_from unless @user.organizations?

    @user.principal_organization.email
  end
end
