# frozen_string_literal: true
# typed: true

# Base Module Validator
module ApplicationValidatorModule
  extend T::Sig

  def inherited(subclass)
    super
    class_name = subclass.name

    validator_module = "#{class_name}ValidatorModule"

    if Object.const_defined?(validator_module)
      module_constant = Object.const_get(validator_module)
      subclass.include(module_constant)
    else
      Rails.logger.debug { "No validation module found for #{validator_module}" }
    end
  end
end
