# frozen_string_literal: true
# typed: true

Organization.find_each do |organization|
  # Set the host name for URL creation
  SitemapGenerator::Sitemap.default_host = "https://www.#{organization.domain}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{organization.name.parameterize}"

  SitemapGenerator::Sitemap.create do
    # Put links creation logic here.
    #
    # The root path '/' and sitemap index file are added automatically for you.
    # Links are added to the Sitemap in the order they are specified.
    #
    # Usage: add(path, options={})
    #        (default options are used if you don't specify)
    #
    # Defaults: :priority => 0.5, :changefreq => 'weekly',
    #           :lastmod => Time.now, :host => default_host
    #
    # Examples:
    #
    # Add '/articles'
    #
    #   add articles_path, :priority => 0.7, :changefreq => 'daily'
    #
    # Add all articles:
    #
    #   Article.find_each do |article|
    #     add article_path(article), :lastmod => article.updated_at
    #   end
    group(filename: organization.name.parameterize) do
      add '/home', changefreq: 'weekly', priority: 0.9, lastmod: Time.zone.today
      add '/about', changefreq: 'weekly', priority: 0.9, lastmod: Time.zone.today
      add '/service', changefreq: 'weekly', priority: 0.9, lastmod: Time.zone.today
      add '/contacts', changefreq: 'weekly', priority: 0.9, lastmod: Time.zone.today
      add '/menu', changefreq: 'daily', priority: 0.9, lastmod: Time.zone.today
      Apartment::Tenant.switch(organization.tenant_name) do
        CatalogCategory.find_each do |category|
          picture = nil
          Apartment::Tenant.switch('public') do
            picture = category.default_picture
          end

          params = {} and params[I18n.t('routes.site.params.menu.category').to_sym] =
                            category.title.parameterize
          default_url_options[:host] = "https://www.#{organization.domain}"

          add(menu_index_path(params:),
              lastmod: category.updated_at,
              images: [{
                loc: url_for(picture),
                title: category.title
              }])
        end
      end
    end
  end
end
SitemapGenerator::Sitemap.create_index = false
