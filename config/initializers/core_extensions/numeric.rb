# frozen_string_literal: true
# typed: true

# CoreExtensions module
module CoreExtensions
  # Module numeric
  module Numeric
    def percent_of(number)
      (to_f / number) * 100.0
    end

    def percent_from(number)
      ((to_f / 100.0) * number.to_f).to_i
    end
  end
end

Numeric.include CoreExtensions::Numeric
