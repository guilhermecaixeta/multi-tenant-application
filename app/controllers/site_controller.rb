# frozen_string_literal: true
# typed: true

# Base Controller
class SiteController < ApplicationController
  layout 'site'
  include RescueConcern
  before_action :load_data
  before_action :define_meta_tags

  helper_method :current_organization

  def index
    nil unless session[:site_organization_id]
  end

  def current_organization
    redirect_to '/500', status: :internal_server_error and return unless session && session[:site_organization_id]

    @current_organization ||= Organization.find(session[:site_organization_id])
  end

  protected

  def load_data
    @categories = CatalogCategory.load_all_for_site
  end

  def keywords_meta_tag
    return if @categories.blank?

    categories = @categories.map(&:title)
    catalogs = @categories.flat_map(&:catalogs).map(&:name)
    (categories + catalogs).take(20).join(', ')
  end

  def twitter_meta_tag
    {}
  end

  def og_meta_tag
    Rails.logger.info { 'Generating og metatags' }
    og_tag = {
      title: controller_name.humanize,
      type: 'website',
      url: menu_index_path,
      image: generate_og_meta_tags_for_categories + generate_og_meta_tags_for_catalogs
    } and Rails.logger.info({ og_tag: }) and og_tag
  end

  private

  def generate_og_meta_tags_for_categories
    @categories.map do |c|
      tag = {
        _: url_for(c.default_picture),
        width: c.default_picture.metadata['width'],
        height: c.default_picture.metadata['height']
      } and Rails.logger.info({ tag:, type: 'attachment' }) and tag
    end
  end

  def generate_og_meta_tags_for_catalogs
    @categories.flat_map(&:catalogs)
               .select { |c| c.picture.attached? }
               .map do |c|
      tag = {
        _: url_for(c.picture),
        width: c.picture.metadata['width'],
        height: c.picture.metadata['height']
      } and Rails.logger.info({ tag:, for: Catalog.name }) and tag
    end
  end

  def define_meta_tags
    if current_organization
      define_meta_tags_for_organization
    else
      define_meta_tags_for_anonymous
    end
  end

  def define_meta_tags_for_organization
    set_meta_tags(
      site: current_organization.name,
      title: controller_name.humanize,
      description: current_organization&.organization_profile&.about&.to_plain_text,
      keywords: keywords_meta_tag,
      twitter: twitter_meta_tag,
      og: og_meta_tag
    )
  end

  def define_meta_tags_for_anonymous
    set_meta_tags(
      site: Rails.configuration.x.application.name,
      title: Rails.configuration.x.application.name,
      keywords: keywords_meta_tag
    )
  end
end
