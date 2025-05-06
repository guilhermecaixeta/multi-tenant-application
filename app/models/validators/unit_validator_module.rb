# frozen_string_literal: true
# typed: true

# Validator Module
module UnitValidatorModule
  extend T::Sig

  sig { params(record: Module).void }
  def self.included(record)
    super

    record.validates :long_name,
                     presence: true
    record.validates :short_name,
                     presence: true,
                     length: { minimum: 1, maximum: 3 }
  end
end
