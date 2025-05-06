# frozen_string_literal: true
# typed: true

# Resource Concern
module ResourceConcern
  extend T::Sig
  extend ActiveSupport::Concern

  included do # rubocop:disable Metrics/BlockLength
    before_action :load_all_paginated, only: [:index]
    before_action :find_or_build_model, except: %i[show index]
    before_action :build_dependencies, only: %i[new]
    before_action :previous_change_action_url, only: %i[new edit]

    protected

    def load_all_paginated
      @pagy, @objects = pagy(policy_scope(model_klass))
    end

    def key_param=(value)
      @key_param = value
    end

    def key_param
      return :id unless @key_param

      @key_param
    end

    sig { returns(ApplicationRecord) }
    def find_or_build_model
      @object ||= if params&.key?(key_param)
                    includes_associations(model_klass).find(params[key_param])
                  else
                    model_klass.build
                  end
    end

    sig { returns(Class) }
    def model_klass
      @model_klass ||= model_klass_name.constantize
    end

    sig { returns(String) }
    def model_klass_name
      return @model_klass_name if @model_klass_name

      @model_klass_name = controller_name.classify

      return @model_klass_name.singularize if @model_klass_name.plural?

      @model_klass_name
    end

    sig { returns(T.untyped) }
    def default_path
      url_for(controller: controller_name, action: :index)
    end

    def previous_change_action_url
      session[:previous_change_action_url] = request.referer
    end

    sig { params(model: T::Class[ApplicationRecord]).returns(T::Class[ApplicationRecord]) }
    def includes_associations(model)
      model
    end

    sig { void }
    def build_dependencies; end
  end
end
