# frozen_string_literal: true

module DomainErrors
  class BaseDomainError < StandardError
  end

  class BadRequestError < BaseDomainError
  end

  class UnprocessableEntityError < BaseDomainError
  end

  class InsufficientBalanceError < BaseDomainError
    def initialize
      super(I18n.t('errors.messages.stock_insuficient_quantity'))
    end
  end

  class MissingParamsError < BadRequestError
    def initialize
      super(I18n.t('errors.messages.domain_errors.missing_params'))
    end
  end

  class MissingRoleNameError < UnprocessableEntityError
    def initialize
      super(I18n.t('errors.messages.domain_errors.missing_role_name'))
    end
  end

  class MissingKlassError < BadRequestError
    def initialize
      super(I18n.t('errors.messages.domain_errors.missing_klass'))
    end
  end

  class NilKlassError < BadRequestError
    def initialize
      super(I18n.t('errors.messages.domain_errors.missing_klass'))
    end
  end
end
