# frozen_string_literal: true

module Site
  class ContactsController < SiteController
    def index; end

    protected

    def load_data
      @categories = []
    end
  end
end
