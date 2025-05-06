# frozen_string_literal: true

module CoreExtensions
  module String
    def plural?
      pluralize == self
    end
  end
end

String.include CoreExtensions::String
