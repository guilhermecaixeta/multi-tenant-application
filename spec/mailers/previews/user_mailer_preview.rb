# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    FactoryBot.register_strategy(:unit_singleton, UnitsSingletonStrategy)
    FactoryBot.register_strategy(:singleton, SingletonStrategy)
    UserMailer.welcome(FactoryBot.build(:user_operator), Devise.friendly_token.first(8))
  end

  def reset_password_instructions
    FactoryBot.register_strategy(:unit_singleton, UnitsSingletonStrategy)
    FactoryBot.register_strategy(:singleton, SingletonStrategy)
    raw, = Devise.token_generator.generate(User, :reset_password_token)
    UserMailer.reset_password_instructions(FactoryBot.build(:user_operator), raw, nil)
  end

  def password_change
    FactoryBot.register_strategy(:unit_singleton, UnitsSingletonStrategy)
    FactoryBot.register_strategy(:singleton, SingletonStrategy)
    UserMailer.password_change(FactoryBot.build(:user_operator), nil)
  end

  def email_change
    FactoryBot.register_strategy(:unit_singleton, UnitsSingletonStrategy)
    FactoryBot.register_strategy(:singleton, SingletonStrategy)
    UserMailer.email_changed(FactoryBot.build(:user_operator), nil)
  end

  def announcements
    FactoryBot.register_strategy(:unit_singleton, UnitsSingletonStrategy)
    FactoryBot.register_strategy(:singleton, SingletonStrategy)
    UserMailer.announcements(FactoryBot.build(:user_operator),
                             I18n.t('email.warning.pepper_migration.subject'),
                             I18n.t('email.warning.pepper_migration.instruction_message',
                                    link: 'https://example.com'))
  end

  private

  def register_strategies; end
end
