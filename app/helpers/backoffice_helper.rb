# frozen_string_literal: true

module BackofficeHelper
  include Pagy::Frontend

  def form_model(object)
    @model_path = controller_path.split('/').map(&:to_sym)
    @model_path[0..-2] << object
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend 'notifications' do
      flash.map do |_type, data|
        content_tag(:div, data)
      end.join.html_safe
    end
  end
end
