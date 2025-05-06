# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

# Base Backoffice Controller
class BackofficeController < ApplicationController
  layout 'backoffice'
  include Pundit::Authorization
  include AuthenticationConcern
  include AuthorizationConcern
  include ResourceConcern
  include RescueConcern

  def initialize
    super
    @page_title = controller_name.humanize
    @page_description = controller_name.humanize
    @page_keywords = controller_path.split('/').join(', ')
  end

  def index; end

  def new; end

  def edit; end

  def create
    @object = model_klass.build permitted_params

    respond_to do |format|
      if @object.valid?

        @object.save!

        format.html do
          redirect_to default_path,
                      notice: t('backoffice.message_created',
                                model_name: model_klass.model_name.human)
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @object.assign_attributes permitted_params

    respond_to do |format|
      if @object.valid?

        @object.save!

        format.html do
          redirect_to default_path,
                      notice: t('backoffice.message_updated',
                                model_name: model_klass.model_name.human)
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    default_name = @object.has_attribute?(:name) ? @object.name : ''

    respond_to do |format|
      if @object.valid? :delete

        @object.destroy

        format.html do
          redirect_back fallback_location: default_path,
                        notice: t('backoffice.message_deleted',
                                  model_name: model_klass.model_name.human,
                                  name: default_name)
        end
      else
        format.html do
          load_all_paginated
          flash.now.alert = @object.errors.map(&:full_message).join("\n")
          render :index, status: :unprocessable_entity
        end
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
