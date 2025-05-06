# frozen_string_literal: true
# typed: true

# Concern
module ControlableConcern
  extend ActiveSupport::Concern

  included do
    has_one :access_control,
            as: :controlable,
            class_name: 'AccessControl',
            dependent: :destroy,
            autosave: true

    delegate :active?, to: :access_control
  end
end
