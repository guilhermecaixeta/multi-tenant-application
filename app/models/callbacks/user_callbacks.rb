# frozen_string_literal: true
# typed: true

# Callback
class UserCallbacks
  extend T::Sig

  sig { params(record: User).void }
  def before_create(record)
    creating_temp_password record
  end

  sig { params(record: User).void }
  def after_create(record)
    UserMailer.welcome(record, record.password).deliver_later
  end

  def before_update(record)
    return unless record.encrypted_password_changed? && record.reset_password_token_changed?

    record.force_password_change = false
  end

  private

  def creating_temp_password(record)
    if T.must(record).password.nil?
      @generated_password = Devise.friendly_token.first(8)
      T.must(record).password = @generated_password
      T.must(record).password_confirmation = @generated_password
    else
      @generated_password = T.must(record).password
    end

    record.confirmed_at = Time.zone.now
  end
end
