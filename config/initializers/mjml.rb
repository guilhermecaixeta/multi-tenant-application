# frozen_string_literal: true

Mjml.setup do |config|
  config.use_mrml = true
  config.template_language = :erb

  # Ignore errors silently
  config.raise_render_exception = false

  # Optimize the size of your emails
  config.beautify = false
  config.minify = true

  # Render MJML templates with errors
  # config.validation_level = "hard"

  # Use MRML instead of MJML, false by default
  config.use_mrml = true
end
