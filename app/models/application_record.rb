# frozen_string_literal: true
# typed: true

# Base class
class ApplicationRecord < ActiveRecord::Base
  extend T::Sig
  extend ApplicationValidatorModule

  primary_abstract_class
end
